# Canvas Resize Sample

From iOS 6, photo can be uploaded from Mobile Safari, however uploading a large file takes a long time.

Resizing the file before upload can save the time and makes a big diffence in the usability.

Javascript canvasResize Plugin(http://canvasresize.gokercebeci.com/) is a very helpful library that can resize a file on client side.

This is a sample Rails app that uses Javascript canvasResize Plugin and paperclip(https://github.com/thoughtbot/paperclip) to demonstrate how to implement file resizing before upload.

# How to implement in your project

To implement "file resizing before upload" in your project, follow the steps below.

1. Copy jquery.canvasResize.js and jquery.exif.js to app/assets/javascripts

2. In _form.html.erb, add the following javascripts inside the head tag:

    <script type="text/javascript">
    
    $().ready(function(){
      $('input#original_post_picture').change(function(e){
        var file = e.target.files[0];
        $('canvas').remove();
        $.canvasResize(file, {
          width   : 300,
          height  : 300,
          crop    : false,
          quality : 80,
          callback: function(data, width, height){
            $('input#post_picture_base64').val(data);
          }
        });
      });
    });
    
    function clear_original_post_picture() {
      $('input#original_post_picture').val('');
    }
    
    </script>
    
3. In _form.html.erb, add the hidden field for base64 data:

    <%= f.hidden_field :picture_base64 %>

    and replace
    
      <%= f.file_field :picture, :id => "photo" %>
    
    with

    <%= file_field_tag 'original_post_picture' %>

4. In _form.html.erb, add

    onclick: "clear_original_post_picture();"

options to submit tag.


5. In your model, add

    attr_accessible :picture_base64
    attr_accessor :picture_base64

6. In create/edit action of your controller, add

      if params[:post][:picture_base64].present?
        /data:image\/(.*);base64,/ =~ params[:post][:picture_base64]
        ext = $1
        data = params[:post][:picture_base64].gsub(/data:image\/.*;base64,/, '')
        file = Tempfile.new(["post_picture", ".#{ext}"])
        file.binmode
        file.write(Base64.decode64 data)
        params[:post][:picture] = file
      end

then, close the file at the end:

    file.close if params[:spot][:picture_base64].present?
