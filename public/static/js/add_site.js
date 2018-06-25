$(function($) {
$("#formularz").on('submit', function(event) {
    event.preventDefault();
    CKEDITOR.instances.id_description.updateElement();
    $.ajax({
        data: $(this).serialize(),
        type: $(this).attr('method'),
        url: $(this).attr('action'),
        success: function(response) {
            if (response['success']) {
                $.alert({
                    title: 'Strona została dodana!',
                    content: (response['success']),
                    theme: 'bootstrap',
                    autoClose: 'success|8000',
                    type: 'green',
                    buttons: {
                        success: {
                            btnClass: 'btn-success',
                            text: 'Powrót do strony głównej',
                            action: function() {
                                window.location.href = '/';
                            }
                        }
                    }
                });
            }
            if (response['error']) {
                $.alert({
                    title: 'Wykryto błąd/błędy!',
                    type: 'red',
                    content: (response['error']),
                    theme: 'bootstrap',
                    buttons: {
                        ok: {
                            text: 'Ok',
                            btnClass: 'btn-red',
                            action: function() {}
                        }
                    }
                });
            }
        }
    });
});
});