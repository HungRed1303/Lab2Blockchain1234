import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
import { Contract } from "ethers";

const deployYourContract: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = hre.deployments;

  // Deploy Balloons token
  await deploy("Balloons", {
    from: deployer,
    args: [],
    log: true,
    autoMine: true,
  });

  const balloons = await hre.ethers.getContract<Contract>("Balloons", deployer);

  // Deploy DEX
  await deploy("DEX", {
    from: deployer,
    args: [await balloons.getAddress()],
    log: true,
    autoMine: true,
  });

  const dex = await hre.ethers.getContract<Contract>("DEX", deployer);

  // Transfer 10 balloons to frontend address
  // THAY ĐỊA CHỈ NÀY bằng địa chỉ frontend của bạn
  await balloons.transfer("0xA223a4f35D718b3614b6e4084Db8ff8856dBAD5E", hre.ethers.parseEther("10"));

  // Init DEX with liquidity
  const dexAddress = await dex.getAddress();
  console.log("Approving DEX to take Balloons...");
  await balloons.approve(dexAddress, hre.ethers.parseEther("100"));

  console.log("Initializing DEX...");
  await dex.init(hre.ethers.parseEther("0.1"), {
    value: hre.ethers.parseEther("0.1"),
    gasLimit: 200000,
  });

  console.log("✅ DEX initialized with 5 ETH and 5 BAL!");
};

export default deployYourContract;
deployYourContract.tags = ["Balloons", "DEX"];
