require 'rails_helper'

RSpec.describe "One Store", :type => :request do
  let!(:book) { create(:book)}
  let(:book_id) { book.id }

  describe 'GET /books' do
    before { get '/api/books'}

    context 'when books are requested' do
      it 'return books' do
        expect(json).not_to be_empty
        expect(json.size).to eq(1)
      end

      it 'returns a status' do
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'GET /books/:id' do
    before { get "/api/books/#{book_id}" }

    context 'when a book exist' do
      it 'return a book' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(book_id)
      end

      it 'returns a status' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when a book does not exist' do
      let (:book_id) { 10 }

      it 'return an error message' do
        expect(response.body).to match(/Couldn't find Book/)
      end

      it 'return a status code' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'POST /books' do
    let(:attributes) { {title: 'Tales', description: 'By moonlight', quantity: 1} }

    context 'when request is valid' do
      before { post "/api/books", params: attributes }

      it 'creates a book' do
        expect(json['title']).to eq('Tales')
      end

      it 'return a status code' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when request is invalid' do
      let(:attributes) { {title: 'Sleep', quantity: 1} }
      before { post '/api/books', params: attributes }

      it 'return a status code' do
        expect(response).to have_http_status(400)
      end

      it 'display an error message' do
        expect(response.body).to match("Description can't be blank")
      end
    end
  end

  describe 'PUT /books/:id' do
    let(:attributes) { {title: 'Cook'} }

    context 'when request is valid' do
      before { put "/api/books/#{book_id}", params: attributes}

      it 'return a status code' do
        expect(response).to have_http_status(204)
      end

      it 'updates record for book' do
        expect(response.body).to be_empty
      end
    end

    context 'when request is invalid' do
      let(:attributes) { {title: ' '} }
      before { put "/api/books/#{book_id}", params: attributes}

      it 'return a status code' do
        expect(response).to have_http_status(400)
      end
    end
  end

  describe 'DELETE /books/:id' do
    before { delete "/api/books/#{book_id}" }

    it 'return a status code' do
      expect(response).to have_http_status(204)
    end
  end
end