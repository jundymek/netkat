$(document).ready(function($) {
    $('.alert').delay(9000).fadeOut();
    $('.bxslider').show().bxSlider({
        mode: 'fade',
        auto: true
    });
    $("label[for='id_category1'], #id_category1, label[for='id_subcategory1'],#id_subcategory1 ").hide();
    
    $('select[name=subcategory1]').prepend('<option value="Not selected" selected disabled>Select Category...</option>');
    // called when category field changes from initial value
     if($('#id_group').val() == '1') {
        $("label[for='id_kod'], #id_kod").hide()
        $("#group").html(base_group_text);
        } else {
            $("#group").html(premium_group_text);
            $("#id_kod").attr("required", "true");
        }
    // $("#group").html(base_group_text);
    $('#id_group').change(function() {
        var $this = $(this);  
        if ($this.find('option:selected').attr('value') == '1') {
            $("#group").html(base_group_text);
            $("#id_kod").removeAttr('required');
            $("label[for='id_kod'], #id_kod").slideToggle("fast");
            $("label[for='id_category1'], #id_category1, label[for='id_subcategory1'],#id_subcategory1").slideToggle("fast");
        } else {
            $("#group").html(premium_group_text);
            $("#id_kod").attr("required", "true");
            $("#group > ul").addClass('premium');
            $("label[for='id_kod'], #id_kod").slideToggle("fast");
            $("label[for='id_category1'], #id_category1, label[for='id_subcategory1'],#id_subcategory1").slideToggle("fast");
        }
    });

    $('#id_category').change(function() {
        var $this = $(this);
        if ($this.find('option:selected').index() !== 0) {
            category_id = $('select[name=category]').val();
            request_url = '/get_subcategory/' + category_id + '/';
            $.ajax({
                url: request_url,
                type: "GET",
                success: function(data) {
                    $('select[name=subcategory]').empty();
                    $.each(data, function(key, value) {
                        $('select[name=subcategory]').append('<option value="' + key + '">' + value + '</option>');
                    });
                }
            })
        }
    });
    $('#id_category1').change(function() {
        var $this = $(this);
        if ($this.find('option:selected').index() !== 0) {
            category_id = $('select[name=category1]').val();
            request_url = '/get_subcategory/' + category_id + '/';
            $.ajax({
                url: request_url,
                type: "GET",
                success: function(data) {
                    $('select[name=subcategory1]').empty();
                    $.each(data, function(key, value) {
                        $('select[name=subcategory1]').append('<option value="' + key + '">' + value + '</option>');
                    });
                }
            })
        }
    });

    // Sprawdzanie tytułu strony, dlugosci, zmiana klasy przy osiagnieciu maksimum
    if ($("#id_name").length != 0) {
        $("label[for='id_name']").html("Tytuł strony <span id=\"title_max\">\
            (" + $("#id_name").val().length + "/" + title_length_max + ")</span>");
        $("#id_name").attr('maxlength', title_length_max);
        if ($("#id_name").val().length == title_length_max || $("#id_name").val().length < title_length_min) {
            $("#title_max").addClass("maxLength");}
    }
    $('#id_name').keyup(function() {
        var charsno = $(this).val().length;
        $("label[for='id_name']").html("Tytuł strony <span id=\"title_max\">(" + charsno + "/" + title_length_max + ")</span>");
        if (charsno == title_length_max || charsno < title_length_min) {
            $("#title_max").addClass("maxLength");
        } else {
            $("#title_max").removeClass("maxLength");
        }
    });

    // Sprawdzanie keywordsow, dlugosci, zmiana klasy przy osiagnieciu maksimum
    if ($("#id_keywords").length != 0) {
        $("label[for='id_keywords']").html("Słowa kluczowe <span id=\"key_max\">\
            (" + $("#id_keywords").val().length + "/" + key_length_max + ")</span>");
        $("#id_keywords").attr('maxlength', key_length_max);
        if ($("#id_keywords").val().length == key_length_max || $("#id_keywords").val().length < key_length_min) {
            $("#key_max").addClass("maxLength");}
    }
    $('#id_keywords').keyup(function() {
        var charsno = $(this).val().length;
        $("label[for='id_keywords']").html("Słowa kluczowe <span id=\"key_max\">(" + charsno + "/" + key_length_max + ")</span>");
        if (charsno == key_length_max || charsno < key_length_min) {
            $("#key_max").addClass("maxLength");
        } else {
            $("#key_max").removeClass("maxLength");
        }
    });

    // Sprawdzanie description, dlugosci, zmiana klasy przy osiagnieciu maksimum
    if ($("#id_description").length != 0 && wyswig != 'tak') {
        $("label[for='id_description']").html("Opis strony <span id=\"desc_max\">\
            (" + $("#id_description").val().length + "/" + desc_length_max + ")</span>");
        $("#id_description").attr('maxlength', desc_length_max);
        if ($("#id_description").val().length == desc_length_max || $("#id_description").val().length < desc_length_min) {
            $("#desc_max").addClass("maxLength");}
    }
    else {
            $("label[for='id_description']").html("Opis strony - max " + desc_length_max + " znaków");
    }
    $('#id_description').keyup(function() {
        var charsno = $(this).val().length;
        $("label[for='id_description']").html("Opis strony <span id=\"desc_max\">(" + charsno + "/" + desc_length_max + ")</span>");
        if (charsno == desc_length_max || charsno < desc_length_min) {
            $("#desc_max").addClass("maxLength");
        } else {
            $("#desc_max").removeClass("maxLength");
        }
    });
});
