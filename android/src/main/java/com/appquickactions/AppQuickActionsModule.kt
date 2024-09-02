package com.appquickactions

import android.annotation.TargetApi
import android.app.Activity
import android.content.Intent
import android.content.pm.ShortcutManager
import android.os.Build
import android.os.Build.VERSION.SDK_INT
import android.os.Parcelable
import android.os.PersistableBundle
import android.util.Log
import androidx.core.content.IntentCompat
import androidx.core.content.pm.ShortcutInfoCompat
import androidx.core.content.pm.ShortcutManagerCompat
import androidx.core.graphics.drawable.IconCompat
import com.facebook.react.bridge.ActivityEventListener
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.modules.core.DeviceEventManagerModule
import com.reactnativeactionsshortcuts.AppQuickActionsItem
import java.util.Timer
import kotlin.concurrent.schedule

class AppQuickActionsModule internal constructor(context: ReactApplicationContext) :
  AppQuickActionsSpec(context), ActivityEventListener {

  override fun getName(): String {
    return NAME
  }

  companion object {
    const val NAME = "AppQuickActions"
    const val QUICK_ACTION_ITEM = "quickActionItem"
    const val INTENT_ACTION_SHORTCUT = "com.react_native_app_quickaction.action.AppQuickActions"
    const val EVENT_ON_SHORTCUT_ITEM_PRESSED = "onQuickActionItemPressed"
  }

  init {
    reactApplicationContext.addActivityEventListener(this)
  }


  @TargetApi(25)
  override fun getInitialShortcut(promise: Promise) {
    if (!isSupported()) {
      promise.reject(NotSupportedException)
    }

    val shortcutItem = getShortcutItemFromIntent(currentActivity?.intent)

    promise.resolve(shortcutItem?.toMap())
  }


  @TargetApi(25)
  override fun setQuickActions(items: ReadableArray?, promise: Promise?) {
    val context = reactApplicationContext ?: return
    val activity = currentActivity ?: return

    val  quickActionsItems = items?.toArrayList()?.mapIndexed { index, _ ->
      val map = items.getMap(index) ?: return
      AppQuickActionsItem.fromReadableMap(map)
    }?.filterNotNull()

    if(quickActionsItems?.isEmpty() == true) {
      NoQuickException.printStackTrace()
      promise?.reject(NoQuickException)
      return
    }

   quickActionsItems?.map {
      val intent = Intent(reactApplicationContext, activity::class.java)
      intent.action = INTENT_ACTION_SHORTCUT
      intent.putExtra(QUICK_ACTION_ITEM, it.toBundle())

      val (type, title, shortTitle, iconName) = it

      val builder = ShortcutInfoCompat
        .Builder(reactApplicationContext, type)
        .setLongLabel(title)
        .setShortLabel(shortTitle)
        .setIntent(intent)

      if(iconName != null) {
        var resourceId = 0
          resourceId = context.resources.getIdentifier(iconName, "drawable", context.packageName)

        if(resourceId==0)
        {
          resourceId = context.resources.getIdentifier("default_ico", "drawable", context.packageName)
        }

        builder.setIcon(IconCompat.createWithResource(context, resourceId))
      }



      ShortcutManagerCompat.pushDynamicShortcut(context,  builder.build())
  }
    }

  @TargetApi(25)
  override fun getQuickActions(promise: Promise) {
    if (!isSupported()) {
      promise.reject(NotSupportedException)
    }

    val shortcutManager = currentActivity?.getSystemService(ShortcutManager::class.java)
    val shortcutItems = shortcutManager?.dynamicShortcuts?.map {
      AppQuickActionsItem(it.id, it.longLabel.toString(), it.shortLabel.toString(), null, null)
    }

    promise.resolve(AppQuickActionsItem.toWritableArray(shortcutItems ?: arrayListOf()))
  }



  @TargetApi(25)
  override fun clearQuickActions() {
    if (!isSupported()) {
      return
    }

    val shortcutManager = currentActivity?.getSystemService(ShortcutManager::class.java)
    shortcutManager?.removeAllDynamicShortcuts()
  }


  override fun addListener(eventType: String?) {

  }

  override fun removeListeners(count: Double) {

  }

  override fun onActivityResult(p0: Activity?, p1: Int, p2: Int, p3: Intent?) {

  }

  override fun onNewIntent(p0: Intent?) {
    val shortcutItem = getShortcutItemFromIntent(p0) ?: return
    sendEvent(shortcutItem)
  }

  private fun sendEvent(shortcutItem: AppQuickActionsItem) {

    reactApplicationContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
      ?.emit(EVENT_ON_SHORTCUT_ITEM_PRESSED, shortcutItem.toMap())


  }

  private fun getShortcutItemFromIntent(intent: Intent?): AppQuickActionsItem? {
    if (intent?.action !== INTENT_ACTION_SHORTCUT) {
      return null
    }

    val bundle =  intent.parcelable<PersistableBundle>(QUICK_ACTION_ITEM)?: return null
    return AppQuickActionsItem.fromPersistentBundle(bundle)
  }

  private inline fun <reified T : Parcelable> Intent.parcelable(key: String): T? = when {
    SDK_INT >= 33 -> getParcelableExtra(key, T::class.java)
    else -> @Suppress("DEPRECATION") getParcelableExtra(key) as? T
  }

  private fun isSupported(): Boolean {
    return Build.VERSION.SDK_INT >= 25
  }

  object NotSupportedException: Throwable("Feature not supported, requires version 25 or above") {
    private fun readResolve(): Any = NotSupportedException
  }
  object NoQuickException:Throwable("There are no quick actions") {
    private fun readResolve(): Any = NoQuickException
  }
}
