import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
import { Contract } from "ethers";

const deployRiggedRoll: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = hre.deployments;

  const diceGame = await hre.ethers.getContract<Contract>("DiceGame", deployer);

  await deploy("RiggedRoll", {
    from: deployer,
    args: [await diceGame.getAddress()],
    log: true,
    autoMine: true,
  });

  const riggedRoll = await hre.ethers.getContract<Contract>("RiggedRoll", deployer);

  const YOUR_FRONTEND_ADDRESS = "0x57C7F128768783bCC5739828B7bF39dC725b2eC7";

  console.log(`Transferring ownership to ${YOUR_FRONTEND_ADDRESS}...`);
  await riggedRoll.transferOwnership(YOUR_FRONTEND_ADDRESS);

  console.log("RiggedRoll deployed and ownership transferred!");
};

export default deployRiggedRoll;
deployRiggedRoll.tags = ["RiggedRoll"];
