package com.chat.truda

import android.Manifest
import android.app.Activity
import android.app.Application
import android.content.Context
import android.os.Bundle
import android.util.Log
import androidx.annotation.RequiresPermission
import java.lang.ref.WeakReference
import java.util.*
import kotlin.system.exitProcess

class TrudaActivityManager private constructor() {

    companion object {
        val INSTANCE by lazy(mode = LazyThreadSafetyMode.SYNCHRONIZED) {
            TrudaActivityManager()
        }
    }

    fun initActivityManager(application: Application) {
        application.registerActivityLifecycleCallbacks(InnerActivityLifecycle())
    }


    private val activityStack: Stack<WeakReference<Activity>?> by lazy { Stack() }
    private val frontBackCallbacks = ArrayList<FrontBackCallback>()
    private var activityStartCount = 0
    var front = true;


    fun getAllActivity(): Stack<WeakReference<Activity>?> {
        return activityStack
    }

    /**
     * 获取activity个数
     *
     * @return
     */
    private fun activitySize(): Int {
        return activityStack.size
    }

    /**
     * 是否有这个activity（这个activity是否在activity栈内）
     *
     * @param cls
     * @return
     */
    fun hasActivity(cls: Class<out Activity>): Boolean {
        activityStack.forEach {
            if (it?.get()?.javaClass == cls) {
                return true
            }
        }
        return false
    }

    /**
     * 获取指定的Activity
     */
    fun getActivity(cls: Class<out Activity>): Activity? {
        val weakReference = findWeakByActivityCls(cls)
        return weakReference?.get()
    }

    private fun findWeakByActivity(activity: Activity): WeakReference<Activity>? {
        activityStack.forEach {
            if (it?.get() === activity) {
                return it
            }
        }
        return null
    }

    private fun findWeakByActivityCls(activityClass: Class<out Activity>): WeakReference<Activity>? {
        activityStack.forEach {
            if (it?.get()?.javaClass == activityClass) {
                return it
            }
        }
        return null
    }

    /**
     * 获取当前activity
     *
     * @return
     */
    fun currentActivity(): Activity? {
        if (activityStack.isNotEmpty()) {
            val temp = activityStack.lastElement()
            return temp?.get()
        }
        return null
    }

    /**
     * 销毁栈顶的activity
     */
    fun finishTopActivity() {
        val activity = activityStack.lastElement()
        if (activity?.get() != null) {
            activity.get()!!.finish()
            activityStack.remove(activity)
        }
    }

    /**
     * 销毁指定的activity
     *
     * @param activityClass
     */
    fun finishActivity(activityClass: Class<out Activity>) {
        activityStack.forEach {
            if (it != null && it.get()?.javaClass == activityClass) {
                finishActivity(it.get())
                return
            }
        }
    }

    /**
     * 销毁指定的activity
     *
     * @param activity
     */
    fun finishActivity(activity: Activity?) {
        if (activity != null) {
            val weakReference = findWeakByActivity(activity)
            if (weakReference?.get() != null) {
                weakReference.get()!!.finish()
                activityStack.remove(weakReference)
            }
        }
    }

    /**
     * 销毁所有activity
     */
    fun finishAllActivity() {
        if (activityStack.isNotEmpty()) {
            for (weakReference in activityStack) {
                if (weakReference?.get() != null) {
                    weakReference.get()!!.finish()
                }
            }
            activityStack.clear()
        }

    }

    /**
     * 销毁所有activity，保留最开始的activity
     */
    fun popAllActivityKeepTop() {
        while (true) {
            if (activitySize() <= 1) {
                break
            }
            val activity = currentActivity() ?: break
            finishActivity(activity)
        }
    }

    /**
     * 销毁所有activity，保留指定activity
     *
     * @param cls
     */
    fun popAllActivityExceptOne(cls: Class<out Activity?>) {
        if (activityStack.isEmpty()) {
            return
        }
        var i = 0
        while (true) {
            val size = activityStack.size
            if (i >= size) {
                return
            }
            val weakReference = activityStack[i]
            i++
            if (weakReference?.get() == null) {
                i--
                activityStack.remove(weakReference)
                continue
            }
            if (weakReference.get()!!.javaClass == cls) {
                continue
            }
            weakReference.get()!!.finish()
            activityStack.remove(weakReference)
            i--
        }
    }

    @RequiresPermission(value = Manifest.permission.KILL_BACKGROUND_PROCESSES)
    fun quitApp(context: Context) {
        try {
            finishAllActivity()
        } catch (e: Exception) {
        }

        // 获取packagemanager的实例
        try {
            val activityMgr =
                context.getSystemService(Context.ACTIVITY_SERVICE) as android.app.ActivityManager
            activityMgr.killBackgroundProcesses(context.packageName)
//            activityStack = null
//            instance = null
        } catch (e: Exception) {
        } finally {
            exitProcess(0)
        }
    }

    /**
     * 添加activity
     *
     * @param activity
     */
    private fun pushActivity(activity: Activity) {
        Log.i("ActivityManager", "当前入栈activity ===>>>" + activity.javaClass.simpleName)
        val item = findWeakByActivity(activity)
        if (item == null) {
            activityStack.add(WeakReference(activity))
        }
    }

    /**
     * 移除activity, 但是不销毁
     *
     * @param activity
     */
    private fun removeActivity(activity: Activity) {
        Log.i("ActivityManager", "当前出栈activity ===>>>" + activity.javaClass.simpleName)
        activityStack.forEach {
            if (it?.get() === activity) {
                activityStack.remove(it)
                return
            }
        }
    }

    private inner class InnerActivityLifecycle : Application.ActivityLifecycleCallbacks {
        override fun onActivityCreated(activity: Activity, savedInstanceState: Bundle?) {
            pushActivity(activity)
        }

        override fun onActivityStarted(activity: Activity) {
            activityStartCount++
            //activityStartCount>0  说明应用处在可见状态，也就是前台
            //!front 之前是不是在后台
            if (!front && activityStartCount > 0) {
                front = true
                onFrontBackChanged(front);
            }
        }

        override fun onActivityResumed(activity: Activity) {}
        override fun onActivityPaused(activity: Activity) {}
        override fun onActivityStopped(activity: Activity) {
            activityStartCount--;
            if (activityStartCount <= 0 && front) {
                front = false
                onFrontBackChanged(front)
            }
        }

        override fun onActivitySaveInstanceState(activity: Activity, outState: Bundle) {}
        override fun onActivityDestroyed(activity: Activity) {
            removeActivity(activity)
        }
    }


    interface FrontBackCallback {
        fun onChanged(front: Boolean)
    }

    private fun onFrontBackChanged(front: Boolean) {
        frontBackCallbacks.forEach {
            it.onChanged(front)
        }
    }

    fun addFrontBackCallback(callback: FrontBackCallback) {
        if (!frontBackCallbacks.contains(callback)) {
            frontBackCallbacks.add(callback)
        }
    }

    // TODO 以后想办法改进成自动反注册的
    fun removeFrontBackCallback(callback: FrontBackCallback) {
        frontBackCallbacks.remove(callback);
    }


}