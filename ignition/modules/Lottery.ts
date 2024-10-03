import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const LotteryModule = buildModule("LotteryModule", (m) => {
  const lottery = m.contract("Lottery");

  return { lottery };
});

export default LotteryModule;

// 0xFBB6986d8a58b4d290D93c294F8CAdeD0a98b9f8
