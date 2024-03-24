"use client";

import {
  MainButton,
  OrganicCircle,
  ListCard,
  Dialog,
} from "@/app/_common/components";
import { useSearchParams } from "next/navigation";
import { QrCode } from "lucide-react";
import { motion, AnimatePresence } from "framer-motion";
import { useEffect, useRef, useState } from "react";
import QRCode from "qrcode.react";
import { cn } from "@/app/_common/lib/utils";
import { Toaster } from "sonner";
import { useWatchContractEvent } from "wagmi";
import { abi, abiGetAddress, abiUSDC } from "../abi";
import { publicClient } from "../client";
import { keccak256 } from "viem";
import * as secp from "@noble/secp256k1";

export default function Home() {
  // const searchParams = useSearchParams();
  // const params = {
  //   pk:
  //     searchParams.get("pk") ??
  //     "0xe4fa494ae6778a7f92a5f88b8c594699c7dee9e8a7bf105c68a9be48fd5ffa3736441828fb7a5a76f360341183197aa94e6aa7bcab44c7169dee9444142bb978",
  //   pv:
  //     searchParams.get("pv") ??
  //     "0xeb3e0a595b8ca73c46a4d083604f2023705d567757b543b9d3c189ad266905bd1db06b9166152bec3d2fd95a102e674e571d02bc0a66a886ede372c37ace82d7",
  //   v:
  //     searchParams.get("v") ??
  //     "0x4b380bf4e5db9bb09053affcf64d5ba145281f6ab051ac569392ae38d8adf0ed",
  //   name: searchParams.get("name") ?? "arron",
  // };
  const params = {
    pk: "0xe4fa494ae6778a7f92a5f88b8c594699c7dee9e8a7bf105c68a9be48fd5ffa3736441828fb7a5a76f360341183197aa94e6aa7bcab44c7169dee9444142bb978",
    pv: "0xeb3e0a595b8ca73c46a4d083604f2023705d567757b543b9d3c189ad266905bd1db06b9166152bec3d2fd95a102e674e571d02bc0a66a886ede372c37ace82d7",
    v: "0x4b380bf4e5db9bb09053affcf64d5ba145281f6ab051ac569392ae38d8adf0ed",
    name: "arron",
  };
  const logContainerRef = useRef<HTMLDivElement>(null);
  const flag = useRef(false);
  const [addresses, setAddresses] = useState<string[]>([]);
  const [balance, setBalance] = useState<number[]>([]);
  const [triggerPulse, setTriggerPulse] = useState(false);

  const getOwnerAddress = (eph: string) => {
    const eph1 = BigInt("0x" + eph.slice(0, 64));
    const eph2 = BigInt("0x" + eph.slice(64));

    const pk1 = BigInt("0x" + params.pk.slice(2, 66));
    const pk2 = BigInt("0x" + params.pk.slice(66));

    const sharedSecret = secp.ProjectivePoint.fromAffine({
      x: eph1,
      y: eph2,
    }).multiply(BigInt(params.v)).x;

    const ownerPublicKey = secp.ProjectivePoint.fromAffine({
      x: secp.CURVE.Gx,
      y: secp.CURVE.Gy,
    })
      .multiply(sharedSecret)
      .add(secp.ProjectivePoint.fromAffine({ x: pk1, y: pk2 }));

    const ownerPublicAddress =
      "0x" +
      keccak256(
        ("0x" + ownerPublicKey.toHex(false).substring(2)) as `0x${string}`
      ).substring(26);

    return ownerPublicAddress;
  };

  const getStealthAddress = async (ownerPublicAddress: string) => {
    const paymasterTokenAddress = "0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238";
    const paymasterAddress = "0x49a92D66587909296b18eCa284b20cDAb58D72e9";
    const salt = 0;

    const data = await publicClient.readContract({
      address: "0x388Dade543Dfc91e755f870403fE250F31e41583",
      abi: abiGetAddress,
      functionName: "getAddress",
      args: [ownerPublicAddress, paymasterTokenAddress, paymasterAddress, salt],
    });
    return data;
  };

  const getBalance = async (address: string) => {
    const data = await publicClient.readContract({
      address: "0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238",
      abi: abiUSDC,
      functionName: "balanceOf",
      args: [address],
    });
    return Number(data as BigInt) / 1e6;
  };

  const getLogs = async () => {
    const logs = await publicClient.getLogs({
      address: "0x7356f4cC77168d0e6f94F1d8E28aeA1316852c0d",
      fromBlock: 5543541n,
      toBlock: "latest",
      event: {
        type: "event",
        name: "Announcement",
        inputs: [
          {
            indexed: true,
            name: "schemeId",
            type: "uint256",
          },
          {
            indexed: true,
            name: "stealthAddress",
            type: "address",
          },
          {
            indexed: true,
            name: "caller",
            type: "address",
          },
          {
            indexed: false,
            name: "ephemeralPubKey",
            type: "bytes",
          },
          {
            indexed: false,
            name: "metadata",
            type: "bytes",
          },
        ],
      },
    });

    const ownerAddress = logs.map((log) =>
      getOwnerAddress(log.args.ephemeralPubKey?.slice(2) as string)
    );

    const stealthAddresses = await Promise.all(
      ownerAddress.map((ownerPublicAddress) =>
        getStealthAddress(ownerPublicAddress)
      )
    );

    const addressArr = new Set<string>();
    logs.forEach((log) => {
      if (
        log.args.stealthAddress &&
        stealthAddresses.includes(log.args.stealthAddress)
      ) {
        addressArr.add(log.args.stealthAddress);
      }
    });
    setAddresses([...addressArr]);

    Promise.all([...addressArr].map((address) => getBalance(address))).then(
      (balanceArr) => {
        setBalance(balanceArr);
      }
    );
  };

  useWatchContractEvent({
    address: "0x7356f4cc77168d0e6f94f1d8e28aea1316852c0d",
    abi,
    eventName: "Announcement",
    onLogs(logs) {
      console.log("New logs!", logs);
      if (!logs[0].args.stealthAddress) return;
      const index = addresses.indexOf(logs[0].args.stealthAddress);
      if (index !== -1) {
        getBalance(logs[0].args.stealthAddress)
          .then((currentBalance) => {
            setBalance([
              ...balance.slice(0, index),
              currentBalance,
              ...balance.slice(index + 1),
            ]);
          })
          .catch((error) => console.log(error));
      } else {
        getLogs();
      }
    },
    chainId: 11155111,
  });

  useEffect(() => {
    if (![...addresses].length) return;
    setTriggerPulse(true);
    setTimeout(() => {
      setTriggerPulse(false);
    }, 1000);
  }, [addresses]);

  useEffect(() => {
    if (flag.current) return;
    flag.current = true;
    getLogs();
  }, []);

  return (
    <main className="min-h-screen px-4">
      <div className="flex flex-col justify-center w-full mb-4">
        <OrganicCircle
          amount={balance.reduce((acc, curr) => acc + curr, 0).toFixed(3)}
          token="USDC"
          className={cn({ "animate-pulse": triggerPulse })}
        />
        <Dialog>
          <Dialog.Trigger asChild>
            <MainButton className="mx-auto -mt-4" icon={<QrCode size={24} />}>
              Receiving
            </MainButton>
          </Dialog.Trigger>
          <Dialog.Content className="bg-slate-600 h-[300px]">
            <Dialog.Header>
              <div className="flex-center size-full">
                <QRCode
                  value={JSON.stringify({
                    pk: params.pk,
                    pv: params.pv,
                    name: params.name,
                  })}
                  imageSettings={{
                    src: "/icons/ninja.png",
                    height: 40,
                    width: 40,
                    excavate: false,
                  }}
                  renderAs="canvas"
                  size={200}
                  bgColor="#475569"
                  fgColor="#cbd5e1"
                />
                ,
              </div>
            </Dialog.Header>
          </Dialog.Content>
        </Dialog>
      </div>
      <div
        className="w-full bg-slate-600 p-2 flex flex-col-reverse gap-2 rounded-lg h-[256px] overflow-y-auto scrollbar-hide"
        ref={logContainerRef}
      >
        <AnimatePresence>
          {[...addresses].map((address, index) => (
            <motion.div
              key={index}
              initial={{ x: "-100%", opacity: 0 }}
              animate={{ x: 0, opacity: 1 }}
              exit={{ x: "-100%", opacity: 0 }}
              transition={{ duration: 0.5 }}
            >
              <ListCard address={address} amount={balance[index]?.toFixed(4) ?? '0'} />
            </motion.div>
          ))}
        </AnimatePresence>
      </div>
      <Toaster richColors />
    </main>
  );
}
