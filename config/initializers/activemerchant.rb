if Rails.env == "development"
  ActiveMerchant::Billing::FirstdataE4Gateway.wiredump_device = File.open(Rails.root.join("log","active_merchant.log"), "a+")
  ActiveMerchant::Billing::FirstdataE4Gateway.wiredump_device.sync = true
  ActiveMerchant::Billing::Base.mode = :test

  login = "wolma606"
  password="dThink151174"
elsif Rails.env == "production"
  login = 'mylogin'
  password='mypassword'
end
GATEWAY = ActiveMerchant::Billing::FirstdataE4Gateway.new({
                                                              login: login,
                                                              password: password
                                                          })