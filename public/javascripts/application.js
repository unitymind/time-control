var commonTable;
var personalTable;

$(document).ready(function() {
    $( '#period_from' ).datepicker({
        showWeek: true
    });

    $( '#period_from' ).datepicker( "option",
				$.datepicker.regional["ru"] );

    $( '#period_to' ).datepicker({
        showWeek: true
    });

    $( '#period_to' ).datepicker( "option",
				$.datepicker.regional["ru"] );

    $( '#department_id' ).change(function() {
        $( '#employee' ).val('');
        $( '#employee_id' ).val('');
    });

    $( '#employee' ).change(function() {
        if ($( '#employee' ).val() == '') {
            $( '#employee_id' ).val('');
        }
    });

    $( '#filter-form').submit(function() {
        $('#datatable-common').hide();
        $('#datatable-personal').hide();
        $('#table-header').html('<h2>Запрашиваем отчет...</h2>');
    });

    $('#datatable-common').html( '<table cellpadding="0" cellspacing="0" border="0" class="display" id="result-common"></table>' );
	commonTable = $('#result-common').dataTable( {
        "oLanguage": {
            "sLengthMenu": "Показать _MENU_ результатов",
            "sInfo": "Результаты с _START_ по _END_ из _TOTAL_",
            "sSearch": "Быстрый поиск:",
            "sEmptyTable": "Данные не найдены",
            "sZeroRecords": "Нет совпадающих записей",
            "oPaginate": {
					"sFirst":    "<<",
					"sPrevious": "<",
					"sNext":     ">",
					"sLast":     ">>"
				}
        },
        "bInfo": false,
        "bJQueryUI": true,
        "bAutoWidth": false,
        "sScrollY": "400px",
        "bPaginate": false,
        "sPaginationType": "full_numbers",
		"aoColumns": [
			{ "sTitle": "Дата" },
			{ "sTitle": "Опоздавших", "sClass": "center"},
			{ "sTitle": "Среднее время<br/>опоздания", "sClass": "center" },
			{ "sTitle": "Всего работало", "sWidth" : '150', "sClass": "center" },
            { "sTitle": "Средняя продолжительность<br /> рабочего дня", "sWidth" : '250', "sClass": "center" }
		]
	} );

    $('#datatable-personal').html( '<table cellpadding="0" cellspacing="0" border="0" class="display" id="result-personal"></table>' );
	personalTable = $('#result-personal').dataTable( {
        "oLanguage": {
            "sLengthMenu": "Показать _MENU_ результатов",
            "sInfo": "Результаты с _START_ по _END_ из _TOTAL_",
            "sSearch": "Быстрый поиск:",
            "sEmptyTable": "Данные не найдены",
            "sZeroRecords": "Нет совпадающих записей",
            "oPaginate": {
					"sFirst":    "<<",
					"sPrevious": "<",
					"sNext":     ">",
					"sLast":     ">>"
				}
        },
        "bInfo": false,
        "bJQueryUI": true,
        "bAutoWidth": false,
        "sScrollY": "400px",
        "bPaginate": false,
        "sPaginationType": "full_numbers",
		"aoColumns": [
			{ "sTitle": "Дата" },
			{ "sTitle": "Начало работы", "sClass": "center" },
			{ "sTitle": "Завершение работы", "sClass": "center" },
			{ "sTitle": "Отработал", "sClass": "center" },
            { "sTitle": "Опоздание?", "sClass": "center",
                "fnRender": function(obj) {
                    if (obj.aData[ obj.iDataColumn ]) {
                        return "Да"
                    } else {
                        return "Нет"
                    }
                }
            },
            { "sTitle": "На сколько опоздал", "sClass": "center" }
		]
	} );
});
