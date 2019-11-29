$(document).ready(function(){

    $('#form_comment').on("ajax:error", function(event) {
        $form = this;
        const errors = event.detail[0];
        $.each(errors, function(field, messages){
            console.log(field);
            console.log(messages);
            $input = $('[name="comment[' + field + ']"]')
            $input.addClass('is-invalid').after("<div class='invalid-feedback'>"+ messages +"</div>")
        });
    })

    $("label").click(function() {
        // let i = $('#' + $(this).attr("for"));
        // console.log(i);
        $('#' + $(this).attr("for")).prop( "checked" );
    });
});


// $('input:radio').change(function() {
//        alert('ole');
//     });
// $('[type*="radio"]').change(function () {
//     let me = $(this);
//     me.attr( 'checked', true );
// $("label[for='"+$(this).attr("id")+"']");
// });