if Rails.env.development?
  env_file = Rails.root.join(".env")
  if env_file.exist?
    development_env = env_file.read
    development_env.lines.each do |line|
      line.chomp!
      match = line.match(/^ *([A-Z0-9a-z_-]+)=(.*)$/)
      if match
        key, value = match[1], match[2]
        value.gsub!(/^"|^'/, '')
        value.gsub!(/"$|'$/, '')
        # yep, this is all we really want in the end
        ENV[key] = value
      end
    end
  end
end
