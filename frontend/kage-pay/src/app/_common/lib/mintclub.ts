import { mintclub } from "mint.club-v2-sdk";

export enum Network {
  ethereum = "ethereum",
  base = "base",
  blast = "blast",
  optimism = "optimism",
  arbitrum = "arbitrum",
  avalanche = "avalanche",
  polygon = "polygon",
  bnbchain = "bnbchain",
  sepolia = "sepolia",
  avalanchefuji = "avalanchefuji",
  blastsepolia = "blastsepolia",
}

export enum CurveType {
  exponential = "EXPONENTIAL",
  linear = "LINEAR",
  logarithmic = "LOGARITHMIC",
  flat = "FLAT",
}

export async function createErc1155() {
  const kgPay = mintclub.network(Network.sepolia).nft("kg-ppay-pay");

  // 🚀 Deploying $MNM-NFT tokens
  const receipt = await kgPay.create({
    name: "Kage Ppay Pay",
    reserveToken: {
      address: "0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238",
      decimals: 18,
    },
    curveData: {
      curveType: CurveType.exponential,
      stepCount: 10,
      maxSupply: 10_000,
      initialMintingPrice: 0.01,
      finalMintingPrice: 0.1,
      creatorAllocation: 100,
    },
    metadataUrl:
      "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.bbc.com%2Fnews%2Fworld-us-canada-37493165&psig=AOvVaw07wVrEDBlK4p_EQ1zE_TJ1&ust=1711286645199000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCIje6Na9ioUDFQAAAAAdAAAAABAE",
  });
  return receipt;
}

export async function getTotalSupply() {
  // 🔍 querying $MNM-NFT on-chain data
  const kgPay = mintclub.network(Network.sepolia).nft("kg-ppay-pay");

  const totalSupply = await kgPay.getTotalSupply();
  return totalSupply;
}

export async function buy() {
  const kgPay = mintclub.network(Network.sepolia).nft("kg-ppay-pay");

  const buyParams = { amount: 100n };
  const buyResult = await kgPay.buy(buyParams);
  return buyResult;
}

export async function sell() {
  const kgPay = mintclub.network(Network.sepolia).nft("kg-ppay-pay");

  const sellParams = { amount: 100n };
  const sellResult = await kgPay.sell(sellParams);
  return sellResult;
}
