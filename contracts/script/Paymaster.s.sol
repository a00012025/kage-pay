// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import "../src/TokenPaymaster.sol";
import "../src/utils/OracleHelper.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DeployPaymasterScript is Script {
    // Define an enum for supported chain IDs
    enum ChainEnum {
        Sepolia,
        OpSepolia,
        ArbSepolia,
        PolygonMumbai
    }

    // Define configuration struct
    struct ChainConfig {
        address tokenOracleAddress;
        address tokenAddress;
        address nativeOracleAddress;
    }

    // Mapping of enum Chain to their configurations
    mapping(uint256 => ChainConfig) public chainConfigs;

    // Mapping of enum Chain to their chain IDs
    mapping(ChainEnum => uint256) public chainIDs;

    function setUp() public {
        // Mapping enum values to chain IDs
        chainIDs[ChainEnum.Sepolia] = 11155111;
        chainIDs[ChainEnum.OpSepolia] = 11155420;
        chainIDs[ChainEnum.ArbSepolia] = 421614;
        chainIDs[ChainEnum.PolygonMumbai] = 80001;
        // chainIDs[ChainEnum.ScrollSepolia] = 534351;
        // chainIDs[ChainEnum.Zircuit] = 48899;

        // Initialize configurations for each chain
        chainConfigs[chainIDs[ChainEnum.Sepolia]] = ChainConfig({
            tokenOracleAddress: 0x694AA1769357215DE4FAC081bf1f309aDC325306,
            tokenAddress: 0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238,
            nativeOracleAddress: address(0x0)
        });
        chainConfigs[chainIDs[ChainEnum.OpSepolia]] = ChainConfig({
            tokenOracleAddress: 0x61Ec26aA57019C486B10502285c5A3D4A4750AD7,
            tokenAddress: 0x5fd84259d66Cd46123540766Be93DFE6D43130D7,
            nativeOracleAddress: address(0x0)
        });
        chainConfigs[chainIDs[ChainEnum.ArbSepolia]] = ChainConfig({
            tokenOracleAddress: 0xd30e2101a97dcbAeBCBC04F14C3f624E67A35165,
            tokenAddress: 0x75faf114eafb1BDbe2F0316DF893fd58CE46AA4d,
            nativeOracleAddress: address(0x0)
        });
        chainConfigs[chainIDs[ChainEnum.PolygonMumbai]] = ChainConfig({
            tokenOracleAddress: 0x0715A7794a1dc8e42615F059dD6e406A6594651A,
            tokenAddress: 0x9999f7Fea5938fD3b1E26A12c3f2fb024e194f97,
            nativeOracleAddress: address(0x0)
        });
    }

    function run() public {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        address deployerAddress = vm.envAddress("ETH_FROM");

        uint256 chainId = block.chainid;
        console.log("Deploying to chainId:", chainId);

        ChainConfig memory config = chainConfigs[chainId];
        require(
            config.tokenAddress != address(0),
            "Chain configuration not set"
        );

        TokenPaymaster.TokenPaymasterConfig
            memory tokenPaymasterConfig = TokenPaymaster.TokenPaymasterConfig({
                priceMarkup: 1e26,
                refundPostopCost: 50000,
                priceMaxAge: 2000000
            });

        OracleHelper.OracleHelperConfig memory oracleHelperConfig = OracleHelper
            .OracleHelperConfig({
                cacheTimeToLive: 86400,
                maxOracleRoundAge: 2000000,
                tokenOracle: IOracle(config.tokenOracleAddress), // Cast the address to IOracle
                nativeOracle: IOracle(config.nativeOracleAddress), // Cast the address to IOracle
                tokenToNativeOracle: true,
                tokenOracleReverse: false,
                nativeOracleReverse: false,
                priceUpdateThreshold: 1e20
            });

        IEntryPoint entryPoint = IEntryPoint(
            0x0000000071727De22E5E9d8BAf0edAc6f37da032
        );
        IERC20Metadata token = IERC20Metadata(config.tokenAddress);

        TokenPaymaster paymaster = new TokenPaymaster(
            token,
            entryPoint,
            tokenPaymasterConfig,
            oracleHelperConfig,
            deployerAddress
        );

        console.log("Deployed TokenPaymaster at:", address(paymaster));

        vm.stopBroadcast();
    }
}