package com.facerecognitionsdk

import android.R
import android.graphics.Color
import android.util.Log
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import android.widget.RelativeLayout
import com.facebook.react.bridge.LifecycleEventListener
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.common.MapBuilder
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.modules.core.DeviceEventManagerModule
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.WritableArray
import com.facebook.react.bridge.*
import io.fotoapparat.Fotoapparat
import io.fotoapparat.parameter.Resolution
import io.fotoapparat.selector.front
import io.fotoapparat.selector.back
import io.fotoapparat.view.CameraView
import io.fotoapparat.util.FrameProcessor
import io.fotoapparat.preview.Frame
import io.fotoapparat.configuration.CameraConfiguration
import android.graphics.Bitmap
import com.kbyai.facesdk.FaceBox
import com.kbyai.facesdk.FaceDetectionParam
import com.kbyai.facesdk.FaceSDK
import java.io.ByteArrayOutputStream

class FaceRecognitionSdkViewManager(private val reactContext: ReactApplicationContext): SimpleViewManager<View>(), LifecycleEventListener{

  private var frontFotoapparat: Fotoapparat? = null
  private var linearLayout: FrameLayout? = null
  private var dummyLayout: FrameLayout? = null
  private var cameraView: CameraView? = null
  private var cameraLens: Int = 0
  private var checkLivenessLevel: Int = 0

  init {
    reactContext.addLifecycleEventListener(this)
    FaceSDKModule.faceRecognitionSdkViewManager = this
  }

  override fun getName() = "FaceRecognitionSdkView"

  override fun createViewInstance(reactContext: ThemedReactContext): View {
    Log.e("TestEngine", "createViewInstance")
    linearLayout = FrameLayout(reactContext).apply {
      layoutParams = FrameLayout.LayoutParams(
        RelativeLayout.LayoutParams.MATCH_PARENT,
        RelativeLayout.LayoutParams.MATCH_PARENT
      )
      setBackgroundColor(Color.parseColor("#000000"))

      cameraView = CameraView(reactContext).apply {
        layoutParams = FrameLayout.LayoutParams(
          ViewGroup.LayoutParams.MATCH_PARENT,
          ViewGroup.LayoutParams.MATCH_PARENT
        )
      }
      addView(cameraView)

//      dummyLayout = FrameLayout(reactContext).apply {
//        layoutParams = FrameLayout.LayoutParams(
//          RelativeLayout.LayoutParams.MATCH_PARENT,
//          RelativeLayout.LayoutParams.MATCH_PARENT
//        )
//        setBackgroundColor(Color.parseColor("#000000"))
//      }
//      addView(dummyLayout)

      frontFotoapparat = Fotoapparat.with(reactContext)
        .into(cameraView!!)
        .lensPosition(front())
        .frameProcessor(SampleFrameProcessor())
        .previewResolution { Resolution(1280, 720) }
        .build()
    }

    return linearLayout!!
  }

  override fun onDropViewInstance(view: View) {
    super.onDropViewInstance(view)

    frontFotoapparat?.stop()
  }
  @ReactProp(name = "color")
  fun setColor(view: View, color: String) {
    view.setBackgroundColor(Color.parseColor(color))
  }

  @ReactProp(name = "livenessLevel")
  fun setLivenessLevel(view: View, livenessLevel: Int) {
    Log.e("TestEngine", "setLivenessLevel " + livenessLevel)
    this.checkLivenessLevel = livenessLevel

    startCamera()
  }

  @ReactProp(name = "cameraLens")
  fun setCameraLens(view: View, cameraLens: Int) {
    Log.e("TestEngine", "setCameraLens " + cameraLens)
    this.cameraLens = cameraLens
  }

  fun startCamera() {
    val configuration = CameraConfiguration()
    if(cameraLens == 1) {
      frontFotoapparat?.switchTo(lensPosition = front(),
        cameraConfiguration = configuration)
    } else {
      frontFotoapparat?.switchTo(lensPosition = back(),
        cameraConfiguration = configuration)
    }

    frontFotoapparat?.start()
  }

  fun stopCamera() {
    frontFotoapparat?.stop()
  }

  override fun onHostResume() {
    Log.e("TestEngine", "onHostResume")
    val configuration = CameraConfiguration()
    if(cameraLens == 1) {
      frontFotoapparat?.switchTo(lensPosition = front(),
        cameraConfiguration = configuration)
    } else {
      frontFotoapparat?.switchTo(lensPosition = back(),
        cameraConfiguration = configuration)
    }

    frontFotoapparat?.start()
  }

  override fun onHostPause() {
    Log.e("TestEngine", "onHostPause")
    frontFotoapparat?.stop()
  }

  override fun onHostDestroy() {
    Log.e("TestEngine", "onHostDestroy")
  }

  private fun sendEvent(reactContext: ReactApplicationContext, eventName: String, params: WritableArray?) {
    reactContext
      .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
      .emit(eventName, params)
  }

  inner class SampleFrameProcessor : FrameProcessor {
    override fun invoke(frame: Frame) {

      var cameraMode = 7
      if (cameraLens == 0) {
        cameraMode = 6
      }

      val bitmap: Bitmap = FaceSDK.yuv2Bitmap(frame.image, frame.size.width, frame.size.height, cameraMode)

      val param = FaceDetectionParam()
      param.check_liveness = true
      param.check_liveness_level = checkLivenessLevel

      val faceBoxesMap: WritableArray = Arguments.createArray()
      var faceBoxes: List<FaceBox>? = FaceSDK.faceDetection(bitmap, param)
      if (!faceBoxes.isNullOrEmpty()) {
        for (face in faceBoxes!!) {
          val faceImage = Utils.cropFace(bitmap, face)
          val templates = FaceSDK.templateExtraction(bitmap, face)

          val byteArrayOutputStream = ByteArrayOutputStream()
          faceImage.compress(Bitmap.CompressFormat.PNG, 100, byteArrayOutputStream)
          val faceJpg: ByteArray = byteArrayOutputStream.toByteArray()

          val e: WritableMap = Arguments.createMap()
          e.putString("x1", face.x1.toString())
          e.putString("y1", face.y1.toString())
          e.putString("x2", face.x2.toString())
          e.putString("y2", face.y2.toString())
          e.putString("liveness", face.liveness.toString())
          e.putString("yaw", face.yaw.toString())
          e.putString("roll", face.roll.toString())
          e.putString("pitch", face.pitch.toString())
          e.putString("templates", Utils.byteArrayToBase64(templates))
          e.putString("faceJpg", Utils.byteArrayToBase64(faceJpg))
          e.putString("frameWidth", bitmap.width.toString())
          e.putString("frameHeight", bitmap.height.toString())
          faceBoxesMap.pushMap(e)
        }
      }
//      Log.e("TestEngine", "face detection: " + bitmap.width)
      sendEvent(reactContext, "onFaceDetected", faceBoxesMap)
      bitmap.recycle()
    }
  }
}
