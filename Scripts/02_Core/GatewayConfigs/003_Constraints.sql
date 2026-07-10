ALTER TABLE core.gateway_configs
  ADD CONSTRAINT ck_gateway_configs_provider
  CHECK (provider IN ('smtp', 'sms_twilio', 'sms_msg91', 'whatsapp', 'stripe', 'razorpay', 'paypal'));
