package expo.modules.pdfpdf

import expo.modules.kotlin.modules.Module
import expo.modules.kotlin.modules.ModuleDefinition
import java.net.URL

import java.io.File
import java.io.FileOutputStream
import kotlin.io.path.createTempDirectory

import android.graphics.Bitmap
import android.graphics.pdf.PdfRenderer
import android.graphics.pdf.PdfRenderer.Page
import android.os.ParcelFileDescriptor

fun getMaxSize(maxWidth: Int, maxHeight: Int, originalWidth: Int, originalHeight: Int): Pair<Int, Int> {
    val aspectRatio = originalWidth.toFloat() / originalHeight.toFloat()
    val scaledWidth = maxWidth
    val scaledHeight = (maxWidth / aspectRatio).toInt()
    if (scaledHeight > maxHeight) {
        val scaledHeightAdjusted = maxHeight
        val scaledWidthAdjusted = (maxHeight * aspectRatio).toInt()
        return Pair(scaledWidthAdjusted, scaledHeightAdjusted)
    }
    return Pair(scaledWidth, scaledHeight)
}

fun uncompress(pdfPath: String): String {
    val srcFile = File(pdfPath)

    val dstDir = createTempDirectory()
    val dstPath = dstDir.toAbsolutePath().toString()

    val parcelFileDescriptor = ParcelFileDescriptor.open(srcFile, ParcelFileDescriptor.MODE_READ_ONLY);
    val renderer = PdfRenderer(parcelFileDescriptor);
    val pageCount = renderer.getPageCount();

    var output: FileOutputStream? = null;
    for (i in 0 until pageCount) {
        val path = "$dstPath/$i.jpg";
        val page = renderer.openPage(i);
        val pageWidth = page.width;
        val pageHeight = page.height;
        val (width, height) = getMaxSize(2560, 2560, pageWidth, pageHeight)
        val bitmap = Bitmap.createBitmap(
            width,
            height,
            Bitmap.Config.ARGB_8888);

        page.render(
            bitmap,
            null,
            null,
            Page.RENDER_MODE_FOR_DISPLAY);

        val file = File(path);
        output = FileOutputStream(file);
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, output);
        page.close();
    }

    return dstPath
}

fun compress(dirPath: String): String {
    throw Exception("Does not support PDF compression")
}

class ExpoPdfPdfModule : Module() {
  // Each module class must implement the definition function. The definition consists of components
  // that describes the module's functionality and behavior.
  // See https://docs.expo.dev/modules/module-api for more details about available components.
  override fun definition() = ModuleDefinition {
    // Sets the name of the module that JavaScript code will use to refer to the module. Takes a string as an argument.
    // Can be inferred from module's class name, but it's recommended to set it explicitly for clarity.
    // The module will be accessible from `requireNativeModule('ExpoPdfPdf')` in JavaScript.
    Name("ExpoPdfPdf")

    Function("compress") { sourcePath: String ->
      return@Function compress(sourcePath)
    }

    Function("uncompress") { sourcePath: String ->
      return@Function uncompress(sourcePath)
    }
  }
}
