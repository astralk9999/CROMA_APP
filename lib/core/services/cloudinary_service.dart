class CloudinaryService {
  static String getOptimizedUrl(String rawUrl, {int? width, int? height}) {
    if (rawUrl.isEmpty) return rawUrl;

    // Si la URL ya está optimizada o no es de cloudinary, la devolvemos
    if (!rawUrl.contains('res.cloudinary.com')) return rawUrl;

    // Formato de Cloudinary: https://res.cloudinary.com/<cloud_name>/image/upload/v<version>/<public_id>
    // Queremos insertar transformaciones: https://res.cloudinary.com/<cloud_name>/image/upload/<transformations>/v<version>/<public_id>

    try {
      final uploadPathIndex = rawUrl.indexOf('upload/') + 'upload/'.length;
      if (uploadPathIndex < 'upload/'.length) return rawUrl;

      final basePath = rawUrl.substring(0, uploadPathIndex);
      final restPath = rawUrl.substring(uploadPathIndex);

      List<String> transforms = [
        'f_auto',
        'q_auto',
      ]; // WebP/AVIF y calidad auto

      if (width != null) transforms.add('w_$width');
      if (height != null) transforms.add('h_$height');

      transforms.add('c_limit'); // No hacer upscale

      final transformString = '${transforms.join(',')}/';

      return '$basePath$transformString$restPath';
    } catch (e) {
      return rawUrl;
    }
  }

  static String get thumbnailTransform => 'w_300,h_400,c_fill,f_auto,q_auto';
  static String get fullTransform => 'w_1200,h_1600,c_limit,f_auto,q_auto';
}
