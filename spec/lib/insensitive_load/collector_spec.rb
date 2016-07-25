require 'spec_helper'

describe InsensitiveLoad::Collector do
  let(:instance) { described_class.new(path_source) }

  shared_context 'relative path in the sample file structure' do
    before {
      Dir.chdir(File.expand_path('../../../sample', __FILE__))
    }

    let(:path_source) { 'ext/soFTwaRe/Config.conf' }
  end

  shared_examples 'to return an instance of Array' do |size|
    it 'return an array' do
      expect(subject).to \
          be_a_kind_of(Array)
    end

    it 'return an array of proper size' do
      expect(subject.size).to \
          eq(size)
    end
  end

  describe 'methods to get data in @collection' do
    describe '#values' do
      subject { instance.values }

      context 'when passed a relative path of existence' do
        include_context \
            'relative path in the sample file structure'

        it_behaves_like \
            'to return an instance of Array',
            3

        it 'return the text in files' do
          is_expected.to \
              all(match(/\AI am '[^']+'.\z*/))
        end
      end
    end
  end

  describe 'methods to get path in @collection' do
    shared_context 'absolute directory in your system' do
      let(:path_source) {
        Gem.win_platform? \
            ? ENV['TEMP'].upcase
            : '/uSR/Bin'
      }
    end

    shared_context 'absolute file in your system' do
      let(:path_source) {
        Gem.win_platform? \
            ? ENV['ComSpec'].upcase
            : '/eTc/HOsTS'
      }
    end

    shared_examples 'initialized by absolute path' do |method_name|
      let(:returner) { instance.send(method_name).map(&:downcase) }

      it 'return the equivalent insensitively' do
        expect(returner).to \
            all(eq(path_source.downcase))
      end
    end

    shared_examples 'initialized by relative path' do |method_name|
      let(:returner) { instance.send(method_name) }

      it 'return an array including absolute path' do
        returner.each do |path|
          matched_head = path.downcase.index(path_source.downcase)
          expect(matched_head).to \
              be > 1
        end
      end
    end

    describe '#items' do
      subject { instance.items }

      context 'when passed a relative path of existence' do
        include_context \
            'relative path in the sample file structure'

        it_behaves_like \
            'to return an instance of Array',
            4

        it_behaves_like \
            'initialized by relative path',
            :items

        context 'with unreasonable "delimiter" option' do
          let(:instance) {
            described_class.new(
                path_source,
                delimiter: 'DELIMITER_STRING')
          }

          it 'return an empty array' do
            expect(subject.size).to \
                eq(0)
          end
        end
      end

      context 'when passed an absolute path of existence' do
        include_context \
            'absolute file in your system'

        it_behaves_like \
            'to return an instance of Array',
            1

        it_behaves_like \
            'initialized by absolute path',
            :items
      end
    end

    describe '#dirs' do
      subject { instance.dirs }

      context 'when passed a relative path of existence' do
        include_context \
            'relative path in the sample file structure'

        it_behaves_like \
            'to return an instance of Array',
            1

        it_behaves_like \
            'initialized by relative path',
            :dirs
      end

      context 'when passed an absolute path of existence' do
        include_context \
            'absolute directory in your system'

        it_behaves_like \
            'to return an instance of Array',
            1

        it_behaves_like \
            'initialized by absolute path',
            :dirs
      end
    end

    describe '#files' do
      subject { instance.files }

      context 'when passed a relative path of existence' do
        include_context \
            'relative path in the sample file structure'

        it_behaves_like \
            'to return an instance of Array',
            3

        it_behaves_like \
            'initialized by relative path',
            :files
      end

      context 'when passed an absolute path of existence' do
        include_context \
            'absolute file in your system'

        it_behaves_like \
            'to return an instance of Array',
            1

        it_behaves_like \
            'initialized by absolute path',
            :files
      end
    end
  end
end