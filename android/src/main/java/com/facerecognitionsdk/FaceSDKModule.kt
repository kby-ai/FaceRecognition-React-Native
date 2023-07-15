package com.facerecognitionsdk
import android.content.ContentResolver
import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.net.Uri
import android.util.Log
import com.facebook.react.bridge.*
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.kbyai.facesdk.FaceBox
import com.kbyai.facesdk.FaceDetectionParam
import com.kbyai.facesdk.FaceSDK
import java.io.ByteArrayOutputStream
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.WritableArray
import com.facerecognitionsdk.Utils
import android.util.Base64
import com.facebook.react.modules.core.DeviceEventManagerModule

class FaceSDKModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

  private var checkLivenessLevel: Int = 0
  private var listenerCount = 0

  companion object {
    public var faceRecognitionSdkViewManager: FaceRecognitionSdkViewManager? = null
  }

  override fun getName() = "FaceSDKModule"

  override fun initialize() {
    super.initialize()
  }

  private fun sendEvent(reactContext: ReactApplicationContext, eventName: String, params: WritableArray?) {
    reactContext
      .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
      .emit(eventName, params)
  }

  @ReactMethod
  fun setActivation(license: String, promise: Promise){
    val ret = FaceSDK.setActivation(license)

    promise.resolve(ret)
  }

  @ReactMethod
  fun initSDK(promise: Promise){
    Log.d("FaceSDKModule", "initSDK")
    val reactContext: ReactApplicationContext = getReactApplicationContext()
    val context: Context = reactContext.getApplicationContext()
    val ret = FaceSDK.init(context.assets)
    promise.resolve(ret)
  }

  @ReactMethod
  fun setParam(checkLivenessLevel: Int, promise: Promise){
    Log.d("FaceSDKModule", "setParam")
    this.checkLivenessLevel = checkLivenessLevel
    promise.resolve(0)
  }

  @ReactMethod
  fun extractFaces(imagePath: String, promise: Promise){
    Log.d("FaceSDKModule", "extractFaces")
    val imageUri = Uri.parse(imagePath)
    val reactContext: ReactApplicationContext = getReactApplicationContext()
    val context: Context = reactContext.getApplicationContext()
    val faceBoxesMap: WritableArray = Arguments.createArray()

    val bitmap: Bitmap? = Utils.getCorrectlyOrientedImage(context, imageUri)
    if(bitmap != null) {
      val param = FaceDetectionParam()
      param.check_liveness = true
      param.check_liveness_level = checkLivenessLevel

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
    }

    promise.resolve(faceBoxesMap)
  }

  @ReactMethod
  fun similarityCalculation(templates1: String, templates2: String, promise: Promise) {
    val similarity = FaceSDK.similarityCalculation(Utils.base64ToByteArray(templates1), Utils.base64ToByteArray(templates2))
    Log.e("TestEngine", "similarityCalculation" + similarity)
    promise.resolve(similarity)
  }

  @ReactMethod
  fun startCamera(promise: Promise) {
    Log.e("TestEngine", "start camera" + faceRecognitionSdkViewManager);
    faceRecognitionSdkViewManager?.startCamera()
    promise.resolve(0)
  }

  @ReactMethod
  fun stopCamera(promise: Promise) {
    Log.e("TestEngine", "stop camera");
    faceRecognitionSdkViewManager?.stopCamera()
    promise.resolve(0)
  }
}
