const deploy = async () => {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contract with the account:", deployer.address);
  const CarsTrackContract = await ethers.getContractFactory("CarsTrackContract");
  const deployed = await CarsTrackContract.deploy();
  console.log("CarsTrack contract is deployed at:", deployed.address);
};
deploy()
  .then(() => process.exit(0))
  .catch((error) => {
    console.log(error);
    process.exit(1);
  });
