import { spaceGrotesk } from "@/app/_common/fonts/fonts";
import { cn, displayAddress } from "@/app/_common/lib/utils";
import Image from "next/image";
import { Copy } from "lucide-react";
import { toast } from "sonner";

export interface ListCardProps {
  address: string;
  amount: string;
  onClick?: (item: string) => void;
}

const ListCard = ({ address, amount, onClick }: ListCardProps) => {
  return (
    <div
      className={cn(
        spaceGrotesk.className,
        "w-full p-2 h-12 bg-primary flex items-center justify-between rounded-xl text-white"
      )}
    >
      <div className="flex-center gap-1">
        <div className="bg-white rounded-full size-7 flex-center mr-2 ">
          <Image
            className="size-5"
            src="/icons/ninja-blade.png"
            alt="blade"
            width={0}
            height={0}
          />
        </div>
        <p>{displayAddress(address)}</p>
        <Copy
          className="size-4"
          onClick={() => {
            navigator.clipboard.writeText(address);
            toast.success("Copied to clipboard!");
          }}
        />
      </div>
      <div className="flex-center gap-1">
        <Image
          className="size-5"
          src="/icons/usdc.svg"
          alt="blade"
          width={0}
          height={0}
        />
        <p className="font-semibold">{amount}</p>
      </div>
    </div>
  );
};

export { ListCard };
