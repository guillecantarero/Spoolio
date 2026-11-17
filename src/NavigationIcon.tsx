export function NavigationIcon({ index }: { index: number }) {
  return <svg className="nav-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
    {index === 0 && <><circle cx="12" cy="12" r="8.5"/><circle cx="12" cy="12" r="3"/><path d="M5.5 7.5 8 9m8 6 2.5 1.5M7.5 18.5 9 16m6-8 1.5-2.5"/></>}
    {index === 1 && <><rect x="3" y="3" width="7" height="7" rx="1.5"/><rect x="14" y="3" width="7" height="7" rx="1.5"/><rect x="3" y="14" width="7" height="7" rx="1.5"/><rect x="14" y="14" width="7" height="7" rx="1.5"/></>}
    {index === 2 && <><path className="nfc-wave nfc-wave-1" d="M5 8a7 7 0 0 1 0 8"/><path className="nfc-wave nfc-wave-2" d="M9 5a12 12 0 0 1 0 14"/><path className="nfc-wave nfc-wave-3" d="M14 2a17 17 0 0 1 0 20"/><path d="M2 11v2"/></>}
    {index === 3 && <><path d="M4 4h6a3 3 0 0 1 2 1 3 3 0 0 1 2-1h6v15h-6a3 3 0 0 0-2 1 3 3 0 0 0-2-1H4Z"/><path d="M12 5v15M7 8h2m6 0h2M7 11h2m6 0h2"/></>}
    {index === 4 && <><path d="m9 3-.5 2-2 1-2-.5-2 3.5L4 10.5v3L2.5 15l2 3.5 2-.5 2 1 .5 2h4l.5-2 2-1 2 .5 2-3.5-1.5-1.5v-3L20 9l-2-3.5-2 .5-2-1-.5-2Z"/><circle cx="11.2" cy="12" r="3"/></>}
  </svg>;
}

export function ScanShape() {
  return <svg className="scan-shape" viewBox="0 0 100 100" aria-hidden="true"><path d="M32 3Q29 3 27 5L5 27Q3 29 3 32V68Q3 71 5 73L27 95Q29 97 32 97H68Q71 97 73 95L95 73Q97 71 97 68V32Q97 29 95 27L73 5Q71 3 68 3Z"/></svg>;
}
