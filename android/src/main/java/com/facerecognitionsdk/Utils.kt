package com.facerecognitionsdk

import android.content.Context
import android.database.Cursor
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Matrix
import android.net.Uri
import android.provider.MediaStore
import android.util.Base64

import com.kbyai.facesdk.FaceBox

import java.io.IOException
import java.io.InputStream

object Utils {

  fun cropFace(src: Bitmap, faceBox: FaceBox): Bitmap {
    val centerX = (faceBox.x1 + faceBox.x2) / 2
    val centerY = (faceBox.y1 + faceBox.y2) / 2
    val cropWidth = ((faceBox.x2 - faceBox.x1) * 1.4f).toInt()

    var cropX1 = centerX - cropWidth / 2
    var cropY1 = centerY - cropWidth / 2
    var cropX2 = centerX + cropWidth / 2
    var cropY2 = centerY + cropWidth / 2
    if (cropX1 < 0) cropX1 = 0
    if (cropX2 >= src.width) cropX2 = src.width - 1
    if (cropY1 < 0) cropY1 = 0
    if (cropY2 >= src.height) cropY2 = src.height - 1


    val cropScaleWidth = 200
    val cropScaleHeight = 200
    val scaleWidth = cropScaleWidth.toFloat() / (cropX2 - cropX1 + 1)
    val scaleHeight = cropScaleHeight.toFloat() / (cropY2 - cropY1 + 1)

    val m = Matrix()

    m.setScale(1.0f, 1.0f)
    m.postScale(scaleWidth, scaleHeight)
    val cropped = Bitmap.createBitmap(src, cropX1, cropY1, (cropX2 - cropX1 + 1), (cropY2 - cropY1 + 1), m,
      true /* filter */)
    return cropped
  }

  fun getOrientation(context: Context, photoUri: Uri): Int {
    val cursor: Cursor? = context.contentResolver.query(photoUri,
      arrayOf(MediaStore.Images.ImageColumns.ORIENTATION), null, null, null)

    if (cursor?.count != 1) {
      return -1
    }

    cursor.moveToFirst()
    return cursor.getInt(0)
  }

  @Throws(IOException::class)
  fun getCorrectlyOrientedImage(context: Context, photoUri: Uri): Bitmap {
    var isStream: InputStream? = context.contentResolver.openInputStream(photoUri)
    val dbo = BitmapFactory.Options()
    dbo.inJustDecodeBounds = true
    BitmapFactory.decodeStream(isStream, null, dbo)
    isStream?.close()

    val orientation = getOrientation(context, photoUri)

    var srcBitmap: Bitmap
    isStream = context.contentResolver.openInputStream(photoUri)
    srcBitmap = BitmapFactory.decodeStream(isStream)
    isStream?.close()

    if (orientation > 0) {
      val matrix = Matrix()
      matrix.postRotate(orientation.toFloat())

      srcBitmap = Bitmap.createBitmap(srcBitmap, 0, 0, srcBitmap.width,
        srcBitmap.height, matrix, true)
    }

    return srcBitmap
  }

  fun byteArrayToBase64(byteArray: ByteArray): String {
    val base64ByteArray = Base64.encode(byteArray, Base64.DEFAULT)
    return String(base64ByteArray)
  }

  fun base64ToByteArray(base64String: String): ByteArray {
    return Base64.decode(base64String, Base64.DEFAULT)
  }
}
