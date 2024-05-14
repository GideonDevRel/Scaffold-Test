import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
import { Contract } from "ethers";


const deployEcommercePlatform: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = hre.deployments;

  // const productPrice = ethers.utils.parseEther("0.00005")

  await deploy("EcommercePlatform", {
    from: deployer,
    args: [],
    log: true,
    autoMine: true,
  });

  const ecommercePlatformContract = await hre.ethers.getContract<Contract>("EcommercePlatform", deployer);
  console.log("EcommercePlatform contract address:", await ecommercePlatformContract.owner() );
};

export default deployEcommercePlatform;

deployEcommercePlatform.tags = ["EcommercePlatform"];
