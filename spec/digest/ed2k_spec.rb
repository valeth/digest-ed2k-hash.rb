# frozen_string_literal: true

require 'spec_helper'

# verified with rhash (https://github.com/rhash/RHash)
TESTFILES = {

    '31d6cfe0d16ae931b73c59d7e0c089c0' => './spec/testfiles/0b',
    '3d8a6f73694a87143dfec4e402462d0e' => './spec/testfiles/9718500b',
    '26c8ef4bca129c4a9574a9782c0e8695' => './spec/testfiles/9728000b',
    '929483f338c061fcef48b1d5cbacfe18' => './spec/testfiles/9737500b'
}.freeze

STRINGS = {

    '31d6cfe0d16ae931b73c59d7e0c089c0' => '',
    '83ff6980515eb8d749238ec12e54baab' => '.',
    '6a49c8fd36b5ebb69c605f44f20c9083' => 'the quick brown fox',
    '19c46ea62015d6ed476300c4dd208c67' => 'jumps over the lazy old dog.'
}.freeze

describe Digest::ED2K do
    TESTFILES.each do |hash, path|
        it "hashes file #{path}" do
            expect(Digest::ED2K.file(path).hexdigest).to eq(hash)
        end
    end

    STRINGS.each do |hash, str|
        it "hashes string '#{str}'" do
            expect(Digest::ED2K.new(str).hexdigest).to eq(hash)
        end
    end

    it 'raises RuntimeError if updating when finalized' do
        d = Digest::ED2K.new('hello')
        d.finish
        expect { d << ' world' }.to raise_error(RuntimeError)
    end
end
