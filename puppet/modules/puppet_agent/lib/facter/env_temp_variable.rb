require 'tmpdir'

Facter.add(:env_temp_variable) do
  setcode {
    (ENV['TEMP'] || Dir.tmpdir).gsub(/\\\s/, " ").gsub(/\//, '\\')
  }
end
