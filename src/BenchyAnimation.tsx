import { useId } from 'react';

/** Perspective Benchy, drawn as a small SVG instead of a raster or 3D scene. */
export function BenchyAnimation({ grounded = false }: { grounded?: boolean }) {
  const id = useId().replace(/:/g, '');
  return <svg className={`benchy-animation ${grounded ? 'is-grounded' : 'is-sailing'}`} viewBox="0 0 320 240" fill="none" aria-hidden="true">
    <defs>
      <linearGradient id={`${id}-hull`} x1="55" y1="137" x2="245" y2="203" gradientUnits="userSpaceOnUse"><stop stopColor="#E7E8EA"/><stop offset="1" stopColor="#A7ADB5"/></linearGradient>
      <linearGradient id={`${id}-front`} x1="111" y1="83" x2="177" y2="162" gradientUnits="userSpaceOnUse"><stop stopColor="#F1F2F3"/><stop offset="1" stopColor="#C6CBD1"/></linearGradient>
    </defs>
    {grounded && <ellipse cx="164" cy="207" rx="126" ry="15" fill="currentColor" opacity=".1"/>}
    <g className="benchy-float"><g className="benchy-boat">
      {/* Open deck and its recessed inner surface. */}
      <path d="M43 146 85 121Q91 118 102 121L164 136 258 110Q282 104 281 116L270 146 173 173 69 166Z" fill="#F5F5F6"/>
      <path d="m59 145 33-18 71 18 96-28-9 20-80 29Z" fill="#9EA5AE"/>
      <path d="m59 145 33-18v24l-15 9Z" fill="#858E99"/>
      {/* Cabin: front, right side, arched doorway and square window. */}
      <path d="m110 78 67 9-2 66-60 15Z" fill={`url(#${id}-front)`}/>
      <path d="m177 87 49-18-5 65-46 19Z" fill="#B1B8C1"/>
      <path d="M129 164v-43c0-23 28-23 28-2v38Z" fill="#89939F"/>
      <path d="M150 108q7 4 7 13v36l-7 2Z" fill="#DCE0E4"/>
      <path d="m189 99 25-9-1 28-25 9Z" fill="#7D8794"/>
      <path d="m189 99 18-6-1 22-18 6Z" fill="var(--page)"/>
      {/* Roof thickness and softly lit top. */}
      <path d="m103 69 73 9 57-17-1 12-55 20-73-9Z" fill="#C8CDD3"/>
      <path d="m103 69 48-25 79 11q6 1 3 6l-57 20-72-8q-3 0-1-4Z" fill="#FAFAFA"/>
      {/* Hollow chimney. */}
      <path d="m139 26 26 2-1 32q-12 7-24-1Z" fill="#CCD1D7"/>
      <path d="m136 24 32 1v8q-16 7-32-1Z" fill="#E9ECEF"/>
      <ellipse cx="152" cy="25" rx="16" ry="6" fill="#F5F6F7"/>
      <ellipse cx="152" cy="25" rx="10" ry="3" fill="#858F9B"/>
      {/* Hull hides the cabin base; raised bow and round porthole. */}
      <path d="M43 146q38 13 81 14 30 2 45-12 8-8 25-12l87-23q-4 43-53 77-11 9-41 10-64 2-119-17-12-5-25-37Z" fill={`url(#${id}-hull)`}/>
      <path d="M43 146q42 11 82 10 24 1 40-12 11-9 29-13l76-21q9-2 11 3l-87 27q-17 4-25 12-16 15-45 13-46-2-79-13Z" fill="#FAFAFA"/>
      <ellipse cx="245" cy="147" rx="10" ry="12" transform="rotate(24 245 147)" fill="#8C96A2"/>
      <ellipse cx="246" cy="146" rx="7" ry="9" transform="rotate(24 246 146)" fill="#E7EBEF"/>
    </g></g>
    {!grounded && <g className="benchy-water" stroke="currentColor" strokeWidth="2" strokeLinecap="round"><path d="M45 208q12-5 24 0t24 0t24 0t24 0t24 0t24 0t24 0t24 0t24 0" opacity=".7"/><path d="M69 222q12-4 24 0t24 0t24 0t24 0t24 0t24 0t24 0" opacity=".25"/></g>}
    {grounded && <g className="benchy-shore" stroke="currentColor" strokeWidth="2" strokeLinecap="round"><path d="M41 209q37-8 75 0t80 0 79 0" opacity=".5"/><path d="m67 219 12-2m139 1 14 2m-82 5 9-1" opacity=".3"/></g>}
  </svg>;
}
