/**
 * #service -> search box
 * #service_id -> result box (for successful searching then clicking/selecting of an item)
 */
$("#service").autocomplete({
  source : function(request, response){
    $.ajax({
      url : "<?=base_url()?>api/service/autocomplete",
      dataType : "json",
      type : "post",
      data : {
        search : request.term
      },
      success : function(data){
        $("#service_id").val("");
        response(data);
      }
    });
  },
  minlength : 2,
  focus : function(event, ui){
    $("#service").val(ui.item.label);
    $("#service_id").val(ui.item.value);
    return false;
  },
  select : function(event, ui){
    $("#service").val(ui.item.label);
    $("#service_id").val(ui.item.value);
    return false;
  }
});
