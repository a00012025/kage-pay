import type { Metadata } from "next";
import { inter } from "@/app/_common/fonts/fonts";
import { Provider } from "./provider";
import "./globals.css";

export const metadata: Metadata = {
  title: "Kage Pay",
  description: "A stealth address payment gateway",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className={inter.className}>
        <Provider>{children}</Provider>
      </body>
    </html>
  );
}
