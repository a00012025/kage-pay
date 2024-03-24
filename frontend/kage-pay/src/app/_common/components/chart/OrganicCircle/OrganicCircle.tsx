import { cn } from "@/app/_common/lib/utils";
import "./style.css";
import { spaceGrotesk } from "@/app/_common/fonts/fonts";

interface OrganicCircleProps {
  amount: string;
  token: string;
  className?: string;
}

const OrganicCircle = ({ amount, token, className }: OrganicCircleProps) => {
  return (
    <div className={cn("mx-auto", className)}>
      <svg
        id="organic-blob"
        width="300"
        height="300"
        xmlns="http://www.w3.org/2000/svg"
        filter="url(#goo)"
      >
        <defs>
          <filter id="goo">
            <feGaussianBlur
              in="SourceGraphic"
              stdDeviation="10"
              result="blur"
            />
            <feColorMatrix
              in="blur"
              mode="matrix"
              values="1 0 0 0 0  0 1 0 0 0  0 0 1 0 0  0 0 0 19 -9"
              result="goo"
            />
            <feComposite in="SourceGraphic" in2="goo" operator="atop" />
          </filter>
        </defs>
        <circle id="Circle1"></circle>
        <circle id="Circle2"></circle>
        <circle id="Circle3"></circle>
        <circle id="Circle4"></circle>

        <text
          x="50%"
          y="50%"
          textAnchor="middle"
          dominantBaseline="middle"
          fill="white"
          fontSize="30"
          letterSpacing="2"
          className={cn(spaceGrotesk.className, "font-bold")}
        >
          <tspan x="50%" y="45%">
            <tspan fontSize="1.3em">{amount.split(".")[0]}</tspan>
            <tspan fontSize="0.7em" dy="0.2em">
              .{amount.includes(".") && amount.split(".")[1]}
            </tspan>
          </tspan>
          <tspan x="50%" y="58%">
            {token}
          </tspan>
        </text>
      </svg>
    </div>
  );
};

export { OrganicCircle };
