<script type="text/javascipt">
  $("#micropost_picture").bind("change", function() {
    var size_in_megabytes = this.files[0].size/1024/1024;
    if (size_in_megabytes > Settings.micropost.max_file) {
      alert( t ".max_file_size");
    }
  });
</script>
