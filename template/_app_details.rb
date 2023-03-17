# Collect the app's metadata

app_name = Rails.application.class.name.partition('::').first.parameterize
