package com.guillecantarero.spoolio;

import android.nfc.NfcAdapter;
import android.os.Handler;
import android.os.Looper;
import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

/** UID only: no memory access, authentication, NDEF reads or writes. */
@CapacitorPlugin(name = "SpoolioNfc")
public class SpoolioNfcPlugin extends Plugin {
  private final Handler handler = new Handler(Looper.getMainLooper());
  private PluginCall pending;
  private NfcAdapter adapter;
  private final Runnable timeout = () -> finish(null, "No se ha detectado una etiqueta en 30 segundos. Vuelve a intentarlo.");

  @PluginMethod public void deviceInfo(PluginCall call) {
    try {
      NfcAdapter current = NfcAdapter.getDefaultAdapter(getContext());
      android.content.pm.PackageInfo info = getContext().getPackageManager()
        .getPackageInfo(getContext().getPackageName(), 0);
      JSObject result = new JSObject();
      result.put("supported", current != null);
      result.put("enabled", current != null && current.isEnabled());
      result.put("version", info.versionName);
      result.put("build", android.os.Build.VERSION.SDK_INT >= 28 ? info.getLongVersionCode() : info.versionCode);
      call.resolve(result);
    } catch (Exception e) { call.reject("No se pudo consultar la información del dispositivo."); }
  }

  @PluginMethod public void scan(PluginCall call) {
    getActivity().runOnUiThread(() -> {
      if (pending != null) { call.reject("Ya hay una lectura NFC en curso."); return; }
      adapter = NfcAdapter.getDefaultAdapter(getContext());
      if (adapter == null) { call.reject("Este dispositivo no tiene NFC."); return; }
      if (!adapter.isEnabled()) { call.reject("Activa NFC en los ajustes del teléfono y vuelve a escanear."); return; }
      pending = call;
      try {
        adapter.enableReaderMode(getActivity(), tag -> {
          byte[] bytes = tag.getId();
          StringBuilder uid = new StringBuilder();
          if (bytes != null) for (byte b : bytes) uid.append(String.format(java.util.Locale.ROOT, "%02X", b & 0xff));
          handler.post(() -> {
            if (pending != call) return;
            finish(uid.length() > 0 ? uid.toString() : null, "Esta etiqueta no proporciona un UID.");
          });
        }, NfcAdapter.FLAG_READER_NFC_A | NfcAdapter.FLAG_READER_NFC_B | NfcAdapter.FLAG_READER_NFC_F | NfcAdapter.FLAG_READER_NFC_V | NfcAdapter.FLAG_READER_SKIP_NDEF_CHECK, null);
        handler.postDelayed(timeout, 30000);
      } catch (Exception e) { finish(null, "No se pudo iniciar NFC. Vuelve a intentarlo con la app abierta."); }
    });
  }
  private void finish(String uid, String error) {
    handler.removeCallbacks(timeout);
    PluginCall call = pending; pending = null;
    if (adapter != null) { try { adapter.disableReaderMode(getActivity()); } catch (Exception ignored) {} }
    if (call == null) return;
    if (uid == null) call.reject(error);
    else { JSObject result = new JSObject(); result.put("uid", uid); call.resolve(result); }
  }
  @PluginMethod public void cancel(PluginCall call) {
    getActivity().runOnUiThread(() -> { finish(null, "Lectura cancelada."); call.resolve(); });
  }
  @Override protected void handleOnPause() { finish(null, "Lectura interrumpida. Vuelve a escanear al regresar a la app."); }
  @Override protected void handleOnDestroy() { finish(null, "Lectura cancelada."); }
}
