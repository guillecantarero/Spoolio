import { useId } from 'react';

/** User-provided helice-limpia.svg, recolored with the catalog profile. */
export function HeliceIcono({ colores, translucido = false, size = 76 }: {
  colores: readonly string[]; translucido?: boolean; size?: number;
}) {
  const uid = useId().replace(/:/g, '');
  const valid = colores.length ? colores.map(c => /^#[0-9a-f]{6}$/i.test(c) ? c : '#92979E') : ['#92979E'];
  return (
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 240 240" width={size} height={size} className="helice-icon" aria-hidden="true" focusable="false">

<defs>
  
  <linearGradient id={`${uid}-material`} gradientUnits="userSpaceOnUse" x1="40" y1="40" x2="205" y2="205">
    {valid.map((color, i) => <stop key={i} offset={valid.length === 1 ? 0 : i / (valid.length - 1)} stopColor={color}/>)}
  </linearGradient>
  <linearGradient id={`${uid}-luz-cuerpo`} x1="0" y1="0" x2="1" y2=".75">
    <stop stopColor="#FFF" stopOpacity=".17"/><stop offset=".45" stopColor="#FFF" stopOpacity="0"/><stop offset="1" stopColor="#000" stopOpacity=".10"/>
  </linearGradient>
  <linearGradient id={`${uid}-sombra-superior`} gradientUnits="userSpaceOnUse" x1="87" y1="74" x2="132" y2="111">
    <stop stopColor="#000" stopOpacity=".02"/><stop offset=".55" stopColor="#000" stopOpacity=".23"/><stop offset="1" stopColor="#000" stopOpacity=".07"/>
  </linearGradient>
  <linearGradient id={`${uid}-sombra-inferior`} gradientUnits="userSpaceOnUse" x1="103" y1="158" x2="149" y2="193">
    <stop stopColor="#000" stopOpacity=".03"/><stop offset=".52" stopColor="#000" stopOpacity=".23"/><stop offset="1" stopColor="#000" stopOpacity=".06"/>
  </linearGradient>
  <linearGradient id={`${uid}-brillo-superior`} gradientUnits="userSpaceOnUse" x1="71" y1="78" x2="87" y2="96">
    <stop stopColor="#FFF" stopOpacity="0"/><stop offset="1" stopColor="#FFF" stopOpacity=".20"/>
  </linearGradient>
  <linearGradient id={`${uid}-brillo-inferior`} gradientUnits="userSpaceOnUse" x1="149" y1="135" x2="166" y2="155">
    <stop stopColor="#FFF" stopOpacity="0"/><stop offset="1" stopColor="#FFF" stopOpacity=".17"/>
  </linearGradient>
  <pattern id={`${uid}-damero`} width="14" height="14" patternUnits="userSpaceOnUse">
    <rect width="14" height="14" fill="#FFF"/><path d="M0 0H7V7H0ZM7 7H14V14H7Z" fill="#C5CBD3"/>
  </pattern>
  <path id={`${uid}-contour`} d="M84 30 C106 29 133 29 156 30 C179 46 200 68 205 87 C210 103 206 115 197 127 C207 142 207 157 198 171 C188 188 170 204 155 214 C135 215 105 215 85 214 C63 199 43 182 37 165 C32 151 36 138 45 126 C33 111 32 97 38 82 C46 63 66 44 84 30Z"/>
  <clipPath id={`${uid}-silhouette`}><use href={`#${uid}-contour`}/></clipPath>
</defs>
<g id={`${uid}-filamento`} clipPath={`url(#${uid}-silhouette)`}>
  
  <rect id={`${uid}-patron-translucido`} width="240" height="240" fill={`url(#${uid}-damero)`} display={translucido ? undefined : "none"}/>
  <rect id={`${uid}-relleno-color`} width="240" height="240" fill={`url(#${uid}-material)`} fillOpacity={translucido ? .65 : 1}/>
  <use href={`#${uid}-contour`} fill={`url(#${uid}-luz-cuerpo)`}/>
  <g id={`${uid}-relieves`}>
    <path d="M137 28 C163 59 124 88 86 112 C56 131 29 149 38 174 C20 149 30 130 57 110 C92 85 142 57 119 28Z" fill={`url(#${uid}-sombra-superior)`}/>
    <path d="M113 28 C137 52 98 80 67 102 C49 115 38 125 39 139 C32 126 42 112 60 98 C89 75 122 52 106 28Z" fill={`url(#${uid}-brillo-superior)`}/>
    <path d="M194 67 C210 99 177 125 142 148 C110 169 76 191 85 214 L103 218 C89 195 122 179 157 156 C194 132 221 107 207 83Z" fill={`url(#${uid}-sombra-inferior)`}/>
    <path d="M185 66 C201 96 168 120 134 142 C101 164 70 186 78 207 L86 215 C76 192 108 171 143 148 C179 124 209 100 191 72Z" fill={`url(#${uid}-brillo-inferior)`}/>
    <path d="M83 31 Q119 28 157 31" fill="none" stroke="#FFF" strokeOpacity=".25" strokeWidth=".7"/>
  </g>
</g>
<use href={`#${uid}-contour`} fill="none" stroke="#7D4636" strokeOpacity=".28" strokeWidth=".65" strokeLinejoin="round"/>
</svg>

  );
}
