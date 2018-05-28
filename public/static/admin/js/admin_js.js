(function($) {

    if ($('#id_group').find('option:selected').attr('value') == '1') {
        $("label[for='id_category1'], #id_category1, label[for='id_subcategory1'],#id_subcategory1 ").hide();
        $("div > fieldset > div.form-row.field-kod").hide()
    }

    $('#id_group').change(function() {
        var $this = $(this);  
        if ($this.find('option:selected').attr('value') == '1') {
            $("#group").html(base_group_text);
            $("div > fieldset > div.form-row.field-kod").hide();
            $("label[for='id_category1'], #id_category1, label[for='id_subcategory1'],#id_subcategory1").hide();
        } else {
            $("#group").html(premium_group_text);
            $("#id_kod").attr("required", "true");
            $("#group > ul").addClass('premium');
            $("div > fieldset > div.form-row.field-kod").show();
            $("label[for='id_category1'], #id_category1, label[for='id_subcategory1'],#id_subcategory1").show();
        }
    })

    $('#changelist-form > div:nth-child(2)').change(function() {
        var $this = $(this);  
        if ($this.find('option:selected').attr('value') == 'delete_sites_email') {
            $("#changelist-form > div:nth-child(3) > fieldset").removeAttr( "disabled" );
            $("#id_email_template ").attr("style", "color: black !important");
           } else {

            $("#changelist-form > div:nth-child(3) > fieldset").attr('disabled', true)
            $("#id_email_template ").attr("style", "color: black !important").attr("style", "color: #ccc !important");}
    })


    $("td.field-group.nowrap:contains('Premium')").closest('tr').addClass('premium');
    $("#result_list > tbody > tr > td.field-group.nowrap").hide();
    $("#result_list > thead > tr > th.sortable.column-group > div.text").hide()

    $('#container > ul').delay(5000).fadeOut();
    var number_regex = /[1-9]\d*/;
    $('#content-main > div.app-mainapp.module > table > tbody > tr.model-inactivesite > th > a').each(function(k, v) {
        var re = new RegExp(number_regex, 'ig');
        if ($(this).text().match(re)) {
            $("#content-main > div.app-mainapp.module > table > tbody > tr.model-inactivesite > th > a").addClass('red_label');
        }
    });
    $('#content-main > div.app-mainapp.module > table > tbody > tr.model-flaggedsite > th > a').each(function(k, v) {
        var re = new RegExp(number_regex, 'ig');
        if ($(this).text().match(re)) {
            $("#content-main > div.app-mainapp.module > table > tbody > tr.model-flaggedsite > th > a").addClass('red_label');
        }
    });

    // Sprawdzanie tytułu strony, dlugosci, zmiana klasy przy osiagnieciu maksimum
    if ($('#id_name').length) {
        $("label[for='id_name']").html("Tytuł strony <span id=\"title_max\">\
            (" + $("#id_name").val().length + "/" + title_length_max + ")</span>");
        $("#id_name").attr('maxlength', title_length_max);
        if ($("#id_name").val().length == title_length_max || $("#id_name").val().length < title_length_min) {
            $("#title_max").addClass("red_label");
        }
    }

    $('#id_name').keyup(function() {
        var charsno = $(this).val().length;
        $("label[for='id_name']").html("Tytuł strony <span id=\"title_max\">(" + charsno + "/" + title_length_max + ")</span>");
        if (charsno == title_length_max || charsno < title_length_min) {
            $("#title_max").addClass("red_label");
        } else {
            $("#title_max").removeClass("red_label");
        }
    });

    // Zliczanie znakow w keywords i description w panelu admina
    // Sprawdzanie keywordsow, dlugosci, zmiana klasy przy osiagnieciu maksimum

    if ($('#id_keywords').length) {
        $("label[for='id_keywords']").html("Słowa kluczowe <span id=\"key_max\">\
                    (" + $("#id_keywords").val().length + "/" + key_length_max + ")</span>");
        $("#id_keywords").attr('maxlength', key_length_max);
        if ($("#id_keywords").val().length == key_length_max || $("#id_keywords").val().length < key_length_min) {
            $("#key_max").addClass("red_label");
        }
    }
    $('#id_keywords').keyup(function() {
        var charsno = $(this).val().length;
        $("label[for='id_keywords']").html("Słowa kluczowe <span id=\"key_max\">\
                (" + $("#id_keywords").val().length + "/" + key_length_max + ")</span>");
        if (charsno == key_length_max || charsno < key_length_min) {
            $("#key_max").addClass("red_label");
        } else {
            $("#key_max").removeClass("red_label");
        }
    });



    // Sprawdzanie description, dlugosci, zmiana klasy przy osiagnieciu maksimum
    if ($("#id_description").length && (wyswig != 'tak')) {
        console.log(wyswig);
        $("label[for='id_description']").html("Opis strony <span id=\"desc_max\">\
                (" + $("#id_description").val().length + "/" + desc_length_max + ")</span>");
        $("#id_description").attr('maxlength', desc_length_max);
        if ($("#id_description").val().length == desc_length_max || $("#id_description").val().length < desc_length_min) {
            $("#desc_max").addClass("red_label");
        }
    } else {
        if ($("#id_description").length) {
            $("label[for='id_description']").html("Opis strony - max " + desc_length_max + " znaków");
        }
    }

    $('#id_description').keyup(function() {
        var charsno = $(this).val().length;
        $("label[for='id_description']").html("Opis strony <span id=\"desc_max\">(" + charsno + "/" + desc_length_max + ")</span>");
        if (charsno == desc_length_max || charsno < desc_length_min) {
            $("#desc_max").addClass("red_label");
        } else {
            $("#desc_max").removeClass("red_label");
        }
    });


    // Ukrywanie kategorii/subkategori w zaleznosci od wybranej grupy
    if ($('#id_group').find('option:selected').attr('value') == '1') {
        $("#group").html(base_group_text);
        $("div > fieldset > div.form-row.field-category1").hide();
        $("div > fieldset > div.form-row.field-subcategory1").hide();
        $("#site_form > div > fieldset > div.form-row.field-kod").hide();
    } 
    if ($('#id_group').find('option:selected').attr('value') == '2') {
        $("#group").html(premium_group_text);
    }
    $('#id_group').change(function() {
        var $this = $(this);
        if ($this.find('option:selected').attr('value') == '1') {
            $("#group").html(base_group_text);
            $("div > fieldset > div.form-row.field-category1").hide();
            $("div > fieldset > div.form-row.field-subcategory1").hide();
            $("#site_form > div > fieldset > div.form-row.field-kod").hide();
        } else {
            $("#group").html(premium_group_text);
            $("#id_kod").attr("required", "true");
            $("#site_form > div > fieldset > div.form-row.field-kod").show();
            $("div > fieldset > div.form-row.field-category1").show();
            $("div > fieldset > div.form-row.field-subcategory1").show();
        }
    })

    // Ukrywanie poszczególnych pól w panelu admina przy wyborach
    $('#id_WPISY_DO_MODERACJI').on('change', function() {
        if ($('#id_WPISY_DO_MODERACJI').val() == 'nie') {
            $("#changelist-form > fieldset:nth-child(5) > table > tbody > tr:nth-child(6)").fadeToggle("slow");
        } else {
            $("#changelist-form > fieldset:nth-child(5) > table > tbody > tr:nth-child(6)").fadeToggle("slow");
        }
    });

    if ($('#id_WPISY_DO_MODERACJI').val() == 'nie') {
        $("#changelist-form > fieldset:nth-child(5) > table > tbody > tr:nth-child(6)").hide();
    }

    $('#id_time').on('change', function() {
        if ($('#id_time').val() == 'N') {
            $("#group_form > div > fieldset > div.form-row.field-days").hide();
        } else {
            $("#group_form > div > fieldset > div.form-row.field-days").show();
        }
    });

    $('#id_CHECK_SITES').on('change', function() {
        if ($('#id_CHECK_SITES').val() == 'nie') {
            $('#changelist-form > fieldset:nth-child(5) > table > tbody > tr:nth-child(2)').fadeToggle("slow");
            $('#changelist-form > fieldset:nth-child(5) > table > tbody > tr:nth-child(3)').fadeToggle("slow");
            $('#changelist-form > fieldset:nth-child(5) > table > tbody > tr:nth-child(4)').fadeToggle("slow");
        } else {
            $('#changelist-form > fieldset:nth-child(5) > table > tbody > tr:nth-child(2)').fadeToggle("slow");
            $('#changelist-form > fieldset:nth-child(5) > table > tbody > tr:nth-child(3)').fadeToggle("slow");
            $('#changelist-form > fieldset:nth-child(5) > table > tbody > tr:nth-child(4)').fadeToggle("slow");
        }
    });
    if ($('#id_CHECK_SITES').val() == 'nie') {
        $('#changelist-form > fieldset:nth-child(5) > table > tbody > tr:nth-child(2)').hide();
        $('#changelist-form > fieldset:nth-child(5) > table > tbody > tr:nth-child(3)').hide();
        $('#changelist-form > fieldset:nth-child(5) > table > tbody > tr:nth-child(4)').hide();
    }



    // Wyswietlanie miniatrurek stron w panelu admina
    $('.field-thumb img').click(function() {
        var $this = $(this);
        if ($(this).hasClass('big')) {
            $(this).removeClass('big');
            $(this).animate({
                "width": 100,
                "height": 100,
            }, "fast")
        } else {
            $(this).addClass('big');
            $(this).animate({
                "width": 350,
                "height": 350,
            }, "fast")
        }
    });

})(django.jQuery);
