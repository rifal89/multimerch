<?php echo $header; ?><?php echo $column_left; ?><?php echo $column_right; ?>

<div id="content"><?php echo $content_top; ?>

  <div class="breadcrumb">
    <?php foreach ($breadcrumbs as $breadcrumb) { ?>
    <?php echo $breadcrumb['separator']; ?><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a>
    <?php } ?>
  </div>
  
  <h1><?php echo $ms_account_withdraw_heading; ?></h1>
  
  <?php if (isset($error_warning) && ($error_warning)) { ?>
  	<div class="warning"><?php echo $error_warning; ?></div>
  <?php } ?>
  <p><?php echo $ms_account_withdraw_balance; ?> <b><?php echo $balance; ?></b></p>
  <p><?php echo $ms_account_withdraw_minimum; ?> <b><?php echo $msconf_minimum_withdrawal_amount; ?></b></p>

	<?php if (!$withdrawal_possible) { ?>
		<div class="attention"><?php echo $ms_account_withdraw_impossible; ?></div>
	<?php } ?>
  <form id="ms-sellerinfo">
    <div class="content">
      <?php if (!$withdrawal_possible) { ?>
  	  <div class="overlay"></div>    
  	  <?php } ?>    
      <table class="ms-product" id="ms-withdrawal">
        <tr>
	          <td><?php echo $ms_account_withdraw_amount; ?></td>
	          <td>
	          	<?php if ($allow_partial_withdrawal) { ?>
	          	<p>
          			<input type="radio" name="withdraw_all" value="0" checked="checked" />
          			<input type="text" name="withdraw_amount" value="<?php echo preg_replace("/[^0-9.]/","",$msconf_minimum_withdrawal_amount); ?>" />
          			<?php echo $currency_code; ?>
          		</p>
	          	<?php } ?>
	          	<p>
	          		<input type="radio" name="withdraw_all" value="1" <?php if (!$allow_partial_withdrawal) { ?>checked="checked"<?php } ?> />
	          		<span><?php echo $ms_account_withdraw_all; ?> (<?php echo $balance; ?>)</span>
	          	</p>
	          	<p class="ms-note"><?php echo $ms_account_withdraw_amount_note; ?></p>
	          	<p class="error" id="error_withdraw_amount"></p>
	          </td>
        </tr>
        <tr>
	          <td><?php echo $ms_account_withdraw_method; ?></td>
	          <td>
	          	<p>
	          		<input type="radio" name="withdraw_method" value="paypal" checked="checked" />
	          		<span><?php echo $ms_account_withdraw_method_paypal; ?></span>
	          	</p>
	          	<p class="ms-note"><?php echo $ms_account_withdraw_method_note; ?></p>
	          	<p class="error" id="error_withdraw_method"></p>
	          </td>
        </tr>
    </table>
	</div>
    <div class="buttons">
    	<div class="left"><a href="<?php echo $back; ?>" class="button"><span><?php echo $button_back; ?></span></a></div>
      <?php if ($withdrawal_possible) { ?>
    	<div class="right"><a class="button" id="ms-submit-request"><span><?php echo $ms_button_submit_request; ?></span></a></div>
  	  <?php } ?>        	
    </div>
    </form>  
  <?php echo $content_bottom; ?></div>
<?php echo $footer; ?>

<script>
$(function() {
	$('input[name="withdraw_all"]').change(function() {
		if ($(this).val() == 1) {
			$('input[name="withdraw_amount"]').attr('disabled','disabled');
		} else {
			$('input[name="withdraw_amount"]').removeAttr('disabled');
		}
	});
	
	$("#ms-submit-request").click(function() {
	    $.ajax({
			type: "POST",
			dataType: "json",
			url: 'index.php?route=account/ms-seller/jxrequestmoney',
			data: $(this).parents("form").serialize(),
			success: function(jsonData) {
				$('.error').text('');
				if (!jQuery.isEmptyObject(jsonData.errors)) {
					for (error in jsonData.errors) {
					    if (!jsonData.errors.hasOwnProperty(error)) {
					        continue;
					    }
					    $('#error_'+error).text(jsonData.errors[error]);
					    console.log(error + " -> " + jsonData.errors[error]);
					    window.scrollTo(0,0);
					    
					}				
				} else {
					console.log('success');
					//location = jsonData['redirect'];
				}
	       	}
		});
	});	
});
</script>