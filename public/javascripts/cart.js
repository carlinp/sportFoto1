
function removeall(cart_path, cart_url) {
    $.ajax({
        url: cart_path+'/remove/all',
        success: function(data) {
            window.location=cart_url+'/checkout';
        }
    });
}

function remove(cart_path, id) {
    $.ajax({
        url: cart_path+'/remove/'+id,
        success: function(data) {
            $('#cart-item-'+id).hide("puff",{},400);
            $('#cart-summary').load(cart_path+'/summary');
            $('#cart-pay-link').load(cart_path+'/paylink');
        }
    })
}

