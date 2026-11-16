import { useId } from 'react';

type Props = {
  colores?: readonly string[];
  montadaEnCarrete?: boolean;
  translucido?: boolean;
  size?: number | string;
  className?: string;
  decorative?: boolean;
  label?: string;
};

/** Geometry from the user-approved bobina-minimalista-v2.svg. */
export function BobinaIcono({ colores, montadaEnCarrete = true, translucido = false, size = 160, className = '', decorative = false, label }: Props) {
  const uid = useId().replace(/:/g, '');
  const ids = { gradient: `${uid}-color`, outerGradient: `${uid}-outer-color`, curvedPaint: `${uid}-curved-paint`, checker: `${uid}-checker`, clip: `${uid}-clip`, title: `${uid}-title` };
  const valid = colores?.length ? colores.map(c => /^#[0-9a-f]{6}$/i.test(c) ? c : '#92979E') : ['#92979E'];
  const name = label ?? `${montadaEnCarrete ? 'Bobina' : 'Refill'} · ${valid.length > 1 ? 'multicolor' : 'un color'} · ${translucido ? 'translúcido' : 'opaco'}`;
  return <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 240 240" width={size} height={size} className={`bobina-icon ${className}`} role={decorative ? undefined : 'img'} aria-hidden={decorative || undefined} aria-labelledby={decorative ? undefined : ids.title} focusable="false">
    {!decorative && <title id={ids.title}>{name}</title>}
    <defs>
      <linearGradient id={ids.gradient} gradientUnits="userSpaceOnUse" x1="51" y1="111" x2="129" y2="111">{valid.map((color, i) => <stop key={i} offset={valid.length === 1 ? 0 : i / (valid.length - 1)} stopColor={color}/>)}</linearGradient>
      <linearGradient id={ids.outerGradient} x1="0" y1="0" x2="1" y2="0">{valid.map((color, i) => <stop key={i} offset={valid.length === 1 ? 0 : i / (valid.length - 1)} stopColor={color}/>)}</linearGradient>
      {/* Opaque paint map follows the elliptical winding. Opacity is applied once
          on the final exterior path, never per strip, so translucency stays even. */}
      <pattern id={ids.curvedPaint} width="240" height="240" patternUnits="userSpaceOnUse">
        <rect width="240" height="240" fill={valid[0]}/>
        {Array.from({ length: valid.length > 1 ? 128 : 0 }, (_, i) => {
          const height = 142 / 128;
          const y = 40 + i * height;
          const curve = 39 * Math.sqrt(Math.max(0, 1 - ((y + height / 2 - 111) / 71) ** 2));
          const inset = montadaEnCarrete ? 10 : 0;
          const left = 90 + curve + inset;
          const width = 56 - inset;
          return <g key={i}><rect x={left} y={y} width={width} height={height + 1.5} fill={`url(#${ids.outerGradient})`}/><rect x={left + width} y={y} width="100" height={height + 1.5} fill={valid[valid.length - 1]}/></g>;
        })}
      </pattern>
      <pattern id={ids.checker} width="16" height="16" patternUnits="userSpaceOnUse"><rect width="16" height="16" fill="#FFFFFF"/><path d="M0 0H8V8H0ZM8 8H16V16H8Z" fill="#C5CBD3"/></pattern>
      <clipPath id={ids.clip}><path d="M90 40 H146 A39 71 0 0 1 146 182 H90 A39 71 0 0 1 90 40 Z M90 91 A11 20 0 1 1 90 131 A11 20 0 1 1 90 91 Z" clipRule="evenodd"/></clipPath>
    </defs>
    {montadaEnCarrete && <g data-part="lateral-trasero" fill="var(--spool-back, #D9D5CA)" stroke="var(--spool-outline, #A39E92)" strokeWidth="2"><ellipse cx="146" cy="111" rx="49" ry="86"/></g>}
    <g data-part="filamento">
      <g clipPath={`url(#${ids.clip})`}>
        {translucido && <rect data-part="damero" x="50" y="39" width="136" height="144" fill={`url(#${ids.checker})`}/>}
        {valid.length === 1 ? <rect data-part="color" x="50" y="39" width="136" height="144" fill={valid[0]} fillOpacity={translucido ? .65 : 1}/> : <>
          {/* Disjoint surfaces: shared elliptical edge, no doubled translucent fill. */}
          <path data-part="color-exterior" d="M90 40 H146 A39 71 0 0 1 146 182 H90 A39 71 0 0 0 90 40 Z" fill={`url(#${ids.curvedPaint})`} fillOpacity={translucido ? .65 : 1}/>
          <ellipse data-part="color-cara" cx="90" cy="111" rx="39" ry="71" fill={`url(#${ids.gradient})`} fillOpacity={translucido ? .65 : 1}/>
        </>}
        <ellipse cx="90" cy="111" rx="39" ry="71" fill="#000" opacity=".07"/>
        <g fill="none" stroke="#FFF" strokeWidth="1.2" opacity=".18">{[104, 116, 128, 140].map(x => <path key={x} d={`M${x} 42 A39 71 0 0 1 ${x} 180`}/>)}</g>
      </g>
      <ellipse data-part="agujero" cx="90" cy="111" rx="11" ry="20" fill="#39414B"/>
    </g>
    {montadaEnCarrete && <g data-part="lateral-delantero" stroke="var(--spool-outline, #A39E92)" strokeWidth="2"><path d="M90 25 A49 86 0 1 1 90 197 A49 86 0 1 1 90 25 Z M90 91 A11 20 0 1 0 90 131 A11 20 0 1 0 90 91 Z" fill="var(--spool-front, #E4E0D5)" fillRule="evenodd"/><ellipse cx="90" cy="111" rx="38" ry="69" fill="none" stroke="var(--spool-inner, #C2BDB0)"/></g>}
  </svg>;
}
