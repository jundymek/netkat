(function($) {
    $(document).ready(function() {
        var number_regex = /[1-9]\d*/;
        $('#content-main > div.app-mainapp.module > table > tbody > tr.model-inactivesite > th > a').each(function(k, v) {
            var re = new RegExp(number_regex, 'ig');
            if ($(this).text().match(re)) {
                $("#content-main > div.app-mainapp.module > table > tbody > tr.model-inactivesite > th > a").addClass('red_label');
            }
        });



        if ($('#id_group').find('option:selected').attr('value') ==
            'podstawowy') {
            $("div > fieldset > div.form-row.field-category1").hide();
            $("div > fieldset > div.form-row.field-subcategory1").hide();
        }
        $('h1').hover(function() {
            $(this).animate({
                "width": 150
            }, "slow");
        }, function() {
            $(this).animate({
                "width": 100
            }, "slow");
        });

        $('#id_group').change(function() {
            var $this = $(this);
            if ($this.find('option:selected').attr('value') == 'premium') {
                $("#group").html('<ul><li>- Możesz dodać wpis do 4 KAT</li>\
                <li>- Możesz dodać wpis do 14 KAT</li></ul>');
                $("div > fieldset > div.form-row.field-category1").slideToggle("fast");
                $("div > fieldset > div.form-row.field-subcategory1").slideToggle("fast");
            } else {
                $("div > fieldset > div.form-row.field-category1").slideToggle("fast");
                $("div > fieldset > div.form-row.field-subcategory1").slideToggle("fast");
            }
        })
    })
})(django.jQuery);