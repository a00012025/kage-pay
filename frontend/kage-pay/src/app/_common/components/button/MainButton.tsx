import React, { forwardRef } from "react";
import { cn } from "@/app/_common/lib/utils";

interface MainButtonProps {
  children: React.ReactNode;
  icon?: React.ReactNode;
  className?: string;
  onClick?: () => void;
}

const MainButton = forwardRef<HTMLButtonElement, MainButtonProps>(
  ({ children, icon, className, onClick }, ref) => {
    return (
      <button
        ref={ref} // 將 ref 添加到 button 元素上
        className={cn(
          "inline-flex self-start h-12 animate-shimmer items-center rounded-md border border-slate-800 bg-gradient-to-r from-slate-800 to-slate-900 px-3 font-medium text-white transition-colors",
          className
        )}
        onClick={onClick}
      >
        {icon && <div className="mr-2">{icon}</div>}
        {children}
      </button>
    );
  }
);
MainButton.displayName = "MainButton";

export { MainButton };
