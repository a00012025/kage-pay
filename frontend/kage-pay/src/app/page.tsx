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
import { useRef, useState } from "react";
import QRCode from "qrcode.react";
import { cn } from "@/app/_common/lib/utils";
import { Toaster } from "sonner";
import { useWatchContractEvent, useReadContract } from "wagmi";
import { abi } from "../abi";
import { publicClient } from "../client";

export default function Home() {
  const searchParams = useSearchParams();
  const logContainerRef = useRef<HTMLDivElement>(null);

  const logs = publicClient
    .getLogs({
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
    })
    .then((logs) => {
      console.log(logs);
    });

  useWatchContractEvent({
    address: "0x7356f4cc77168d0e6f94f1d8e28aea1316852c0d",
    abi,
    eventName: "Announcement",
    onLogs(logs) {
      console.log("New logs!", logs);
    },
    chainId: 11155111,
  });

  const params = {
    pk:
      searchParams.get("pk") ??
      "0xe4fa494ae6778a7f92a5f88b8c594699c7dee9e8a7bf105c68a9be48fd5ffa3736441828fb7a5a76f360341183197aa94e6aa7bcab44c7169dee9444142bb978",
    pv:
      searchParams.get("pv") ??
      "0xeb3e0a595b8ca73c46a4d083604f2023705d567757b543b9d3c189ad266905bd1db06b9166152bec3d2fd95a102e674e571d02bc0a66a886ede372c37ace82d7",
    v:
      searchParams.get("v") ??
      "0x4b380bf4e5db9bb09053affcf64d5ba145281f6ab051ac569392ae38d8adf0ed",
    name: searchParams.get("name") ?? "arron",
  };

  const [addresses, setAddresses] = useState<string[]>([
    "0x3Aa3F2947495d4c33845cF1B374f217E76F4CDE3",
    "0x3Aa3F2947495d4c33845cF1B374f217E76F4CDE3",
  ]);
  const [addrMetadata, setAddrMetadata] = useState({
    pk: "0x3Aa3F2947495d4c33845cF1B374f217E76F4CDE3",
    pv: "0x3Aa3F2947495d4c33845cF1B374f217E76F4CDE3",
  });
  const [triggerPulse, setTriggerPulse] = useState(false);

  const showMetadata = () => {
    // qrcode
  };

  const updateLogs = (log: any) => {
    setAddresses([...addresses, "0x3Aa3F2947495d4c33845cF1B374f217E76F4CDE8"]);
    console.log(logContainerRef.current);
    logContainerRef.current?.scrollTo(0, 0);
  };

  console.log(params);

  return (
    <main className="min-h-screen px-4">
      <div className="flex flex-col justify-center w-full mb-4">
        <OrganicCircle
          amount="9987.243"
          token="USDC"
          className={cn({ "animate-pulse": triggerPulse })}
        />
        {/* <MainButton
          className="mx-auto -mt-4"
          icon={<QrCode size={24} />}
          onClick={() => updateLogs("aa")}
        >
          add
        </MainButton> */}
        <Dialog>
          <Dialog.Trigger asChild>
            <MainButton
              className="mx-auto -mt-4"
              icon={<QrCode size={24} />}
              onClick={showMetadata}
            >
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
          {addresses.map((address, index) => (
            <motion.div
              key={index}
              initial={{ x: "-100%", opacity: 0 }}
              animate={{ x: 0, opacity: 1 }}
              exit={{ x: "-100%", opacity: 0 }}
              transition={{ duration: 0.5 }}
            >
              <ListCard amount="9987.22" address={address} />
            </motion.div>
          ))}
        </AnimatePresence>
      </div>
      <Toaster richColors />
    </main>
  );
}
