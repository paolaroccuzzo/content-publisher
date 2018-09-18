//= require vendor/cropperjs/dist/cropper.js

var $imageCroppers = document.querySelectorAll('[data-module="image-cropper"]')

/* eslint-disable */
if ($imageCroppers) {
  $imageCroppers.forEach(function ($imageCropper) {
    var $image = $imageCropper.querySelector('.app-c-image-cropper__image')
    var $cropX = $imageCropper.querySelector('input[name="crop_x"]')
    var $cropY = $imageCropper.querySelector('input[name="crop_y"]')
    var $cropWidth = $imageCropper.querySelector('input[name="crop_width"]')
    var $cropHeight = $imageCropper.querySelector('input[name="crop_height"]')

    var width = $image.clientWidth
    var height = $image.clientHeight
    var naturalWidth  = $image.naturalWidth
    var naturalHeight  = $image.naturalHeight
    var resizeRatio = 1
    var minCropBoxWidth = 960
    var minCropBoxHeight = 640
    var cropX = parseInt($cropX.value)
    var cropY = parseInt($cropY.value)
    var cropWidth = parseInt($cropWidth.value)
    var cropHeight = parseInt($cropHeight.value)

    if (width < naturalWidth || height < naturalHeight) {
      var resizeRatio = width/naturalWidth
      var minCropBoxWidth = minCropBoxWidth * resizeRatio
      var minCropBoxHeight = minCropBoxHeight * resizeRatio
      var cropX = cropX * resizeRatio
      var cropY = cropY * resizeRatio
      var cropWidth = cropWidth * resizeRatio
      var cropHeight = cropHeight * resizeRatio
    }

    if ($image){
      var cropper = new Cropper($image,{
        viewMode: 2,
        aspectRatio: 3 / 2,
        autoCrop: true,
        autoCropArea: 1,
        guides: false,
        zoomable: false,
        highlight: false,
        minCropBoxWidth: minCropBoxWidth,
        minCropBoxHeight: minCropBoxHeight,
        ready() {
          this.cropper.setCropBoxData({
            left: cropX,
            top: cropY,
            width: cropWidth,
            height: cropHeight
          })
        }
      })
      $image.addEventListener('crop', function(data) {
        console.log(data.detail)
        // $cropX.value = data.detail.x
        // $cropY.value = data.detail.y
        // $cropWidth.value = data.detail.width
        // $cropHeight.value = data.detail.height
      })
    }
  })
}
/* eslint-enable */
