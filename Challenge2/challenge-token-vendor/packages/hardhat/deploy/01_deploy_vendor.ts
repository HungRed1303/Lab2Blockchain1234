import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
import { Contract } from "ethers";

const deployVendor: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = hre.deployments;

  const yourToken = await hre.ethers.getContract<Contract>("YourToken", deployer);

  await deploy("Vendor", {
    from: deployer,
    args: [await yourToken.getAddress()],
    log: true,
    autoMine: true,
  });

  const vendor = await hre.ethers.getContract<Contract>("Vendor", deployer);

  console.log("Transferring 1000 tokens to Vendor...");
  await yourToken.transfer(await vendor.getAddress(), hre.ethers.parseEther("1000"));

  // THAY ĐỊA CHỈ NÀY bằng địa chỉ góc trên phải web của bạn
  const YOUR_FRONTEND_ADDRESS = "0x57C7F128768783bCC5739828B7bF39dC725b2eC7";

  console.log(`Transferring ownership to ${YOUR_FRONTEND_ADDRESS}...`);
  await vendor.transferOwnership(YOUR_FRONTEND_ADDRESS);

  console.log("✅ Vendor setup complete!");
};

export default deployVendor;
deployVendor.tags = ["Vendor"];
