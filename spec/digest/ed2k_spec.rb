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
    '19c46ea62015d6ed476300c4dd208c67' => 'jumps over the lazy old dog.',
    'b64b28984897dca4f27956ecc799c7e5' => ('0123456789' * 971850),
    '061519cdd83c3163ef9961484ae89a49' => ('0123456789' * 972800),
    'ed3c82985424bcbfbc652e5d82d1825e' => ('0123456789' * 972800 * 2),
    'ef16c228530f6fe852051cd0f44126d2' => ('0123456789' * 973750)
}.freeze

describe Digest::ED2K do
    TESTFILES.each do |hash, path|
        it "hashes file #{path} of size #{File.size(path)}" do
            expect(Digest::ED2K.file(path).hexdigest).to       eq(hash)
            expect(Digest::ED2K.hexdigest(File.open(path))).to eq(hash)
        end
    end

    STRINGS.each do |hash, str|
        it "hashes string '#{str[0..30]}#{'...' if str.size > 30}' of size #{str.size}" do
            expect(Digest::ED2K.hexdigest(str)).to eq(hash)
        end
    end

    it 'raises RuntimeError if updating when finalized' do
        d = Digest::ED2K.new
        d << 'hello'
        d.finish
        expect { d << ' world' }.to raise_error(RuntimeError)
    end

    it 'cannot hash non String or IO objects' do
        expect { Digest::ED2K.hexdigest(Object.new) }.to raise_error(ArgumentError)
    end
end
