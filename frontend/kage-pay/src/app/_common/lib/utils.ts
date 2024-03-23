import clsx, { ClassValue } from "clsx";
import { twMerge } from "tailwind-merge";

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}

export function displayAddress(address: string) {
  const firstPart = address.substring(0, 6);
  const lastPart = address.substring(address.length - 6);
  return `${firstPart}....${lastPart}`;
}
