require 'sinatra'

describe "http methods" do 
	# these tests should include 
	# get, post, delete, head, put, options (all part of rfc2616)
	# patch
	# link, unlink

			#context returning full rack response [200, {}, ["body"]]
			#context returning the body as a string "Hello World!"
			#context returning the body as an array ["a", "b", "c"]
			#context returning the body as an io object File.open("source_file")
	describe "get" do

		before(:each) do 
			@app = Sinatra.new do 
				get '/' do
					[200, {}, ["a", "b", "c"]]
				end
			end
		end

		it "returns 200 as a status" do
			response = @app.call 'REQUEST_METHOD' => 'GET', 'rack.input' => ''
			expect(response[0]).to eq 200
		end

		it "returns body as string" do
			response = @app.call 'REQUEST_METHOD' => 'GET', 'rack.input' => ''
			expect(response[2][0]).to eq 'a'
		end

		it "returns body as array" do
			response = @app.call 'REQUEST_METHOD' => 'GET', 'rack.input' => ''
			expect(response[2]).to eq ["a", "b", "c"]
		end

		it "/hello routes gets hello" do
			app = Sinatra.new do
				get '/hello' do
					[200, {}, '']
				end
			end
			response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/hello', 'rack.input' => ''
			expect(response[0]).to eq 200
		end

		it "return yield call" do
			app = Sinatra.new do
				get '/' do
					res = lambda { 'Hello World' }
      	  def res.each ; yield call ; end
        	return res
        end
      end
			response = app.call 'REQUEST_METHOD' => 'GET', 'rack.input' => ''
			expect(response[0]).to eq 200
		end

		it "returns empty array when body is nil" do
			app = Sinatra.new do
				get '/' do
					[200, {}, nil]
				end
			end
			response = app.call 'REQUEST_METHOD' => 'GET', 'rack.input' => ''
			expect(response[2]).to eq []
		end

		it "supports params like /hello/:name" do
			app = Sinatra.new do
				get '/hello/:name' do
					[200, {}, [params[:name]]]
				end
			end
			response = app.call 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/hello/horst', 'rack.input' => ''
			p response
			expect(response[2]).to eq ["horst"]
		end

	end
end


# describe "settings" do
# these tests should include setting status, body, headers
#end


#describe "route flow" do
#  these tests should include before and after filters
#  and passing and halting
#end

