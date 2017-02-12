# frozen_string_literal: true

require 'digest'
require 'openssl'

module Digest
    class ED2K < Digest::Class
        CHUNK_SIZE = 9_728_000

        def initialize(data = nil)
            @md4 = OpenSSL::Digest::MD4.new
            reset
            self << data unless data.nil?
        end

        def io(io)
            while (buf = io.read(CHUNK_SIZE))
                self << buf
            end

            self
        end

        def file(path)
            File.open(path) do |file|
                return io(file)
            end
        end

        def reset
            @buf = ''
            @md4.reset
            @finalized = false
            @small = true

            self
        end

        def update(data)
            raise RuntimeError if @finalized

            @buf += data
            hash

            self
        end

        alias << update

        def digest(str = nil)
            if str.nil?
                finish
                @md4.digest
            else
                reset
                self << str
                digest
            end
        end

        def digest!
            dig = digest
            reset

            dig
        end

        def hexdigest(str = nil)
            if str.nil?
                finish
                @md4.hexdigest
            else
                reset
                self << str
                hexdigest
            end
        end

        def hexdigest!
            hex = hexdigest
            reset

            hex
        end

        def finish
            unless @finalized
                if @small
                    @md4.reset
                    @md4 << @buf
                else
                    @md4 << OpenSSL::Digest::MD4.digest(@buf)
                end

                @buf = ''
                @finalized = true
            end

            self
        end

        def inspect
            if @finalized
                "#<ed2k hash='#{digest}'>"
            else
                '#<ed2k unfinalized>'
            end
        end

        class << self
            def digest(data)
                new(data).digest
            end

            def hexdigest(data)
                new(data).hexdigest
            end

            def io(io)
                new.io(io)
            end

            def file(path)
                new.file(path)
            end
        end

        private

        def hash
            while @buf.size >= CHUNK_SIZE
                @small = false
                @md4 << OpenSSL::Digest::MD4.digest(@buf.slice!(0...CHUNK_SIZE))
            end
        end
    end
end
