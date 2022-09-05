--[[
因为不习惯Roblox的http方式，
所以仿着PHP的API写了一个模组脚本
此版本在2021-11-14已停止制作
上传此版本只是想让别人啃屎山 :)
]]

-- Service --
local httpservice = game:GetService("HttpService");

local http = {};
http.json = {};


--	一个普通的获得内容的函数
--- @param url string 获取请求的网址，可以使用ip但必须加上http/https才可以使用，不然报错
--- @param nochace boolean 需不需要Roblox进行缓存
--- @param headers string 特定http头部请求(如果网页有特别需要)
--- @param isjson boolean 为了方便自己以及不想多填写重复代码写的判断
--- @return json|string|error
http.get = function(url, nochace, headers, isjson)

	print("检测到使用此函数，检测设置中...");

	--默认设置
	if url == nil or (url.find(url,"http://") == nil and url.find(url,"https://") == nil) or type(url) ~= "string" then
		error("请设置您的获取地址");
		return;
	end

	if url.find(url,"http://") and url.find(url,"https://") == nil then
		warn("检测到没有使用SSL/HTTPS协议，确保您的数据安全，十分建议您使用https协议进行通信，除非您的网站不受https支持");
		warn("如果您使用的公共网站不支持https协议，请及时作出更换，因为这代表着您的数据不够安全");
		warn("只是一条建议，并不影响您的使用 ;)");
    end

	if nochace == nil or type(nochace) ~= "boolean" then
		warn("您并没有设置nochace，已自动设置为false");
		nochace = false;
	end

	if isjson == nil or type(isjson) ~= "boolean" then
		warn("您并没有设置isjson，已自动设置为false");
		isjson = false;
	end

	--基本检测

	print("默认设置已完成，执行获取函数");

	local response = httpservice:GetAsync(url, nochace, headers);

	if response then
		print("正确获取到了http")
		if isjson then
			print("用户设置此请求是JSON格式，正在解码成Roblox格式...")
			local jsondecode = httpservice:JSONDecode(response);
			if jsondecode then
				print("解码完成");
				print("函数执行完成");
				return jsondecode
			else
				error("解码失败，请检查格式是否正确");
				return;
			end
		else
			print("函数执行完成");
			return response;
		end

	else
		error("获取http失败，请检查您的编码格式是否正确，或检查您的网站是否能被Roblox获取到");
		return;
	end

end

-- 向网站发包
--- @param url string 获取请求的网址，可以使用ip但必须加上http/https才可以使用，不然报错
--- @param data Enum.HttpContentType 需要传输的数据
--- @param ContentType string 关于xxx填什么(对着名称/Name)	-	https://developer.roblox.com/en-us/api-reference/enum/HttpContentType
--- @param compress boolean 是否将您的json文本压缩
--- @param headers string 特定http头部请求(如果网页有特别需要)
--- @param isjson boolean 为了方便自己以及不想多填写重复代码写的判断
http.post = function(url, data, contenttype, compress, headers, isjson)

	print("检测到使用此函数，检测设置中...");

	--默认设置

	local text;

	if url == nil or (url.find(url,"http://") == nil and url.find(url,"https://") == nil) or type(url) ~= "string" then
		error("设置有误，请设置您的获取地址");
		return;
	end

	if url.find(url,"http://") and url.find(url,"https://") == nil then
		warn("检测到没有使用SSL/HTTPS协议，确保您的数据安全，十分建议您使用https协议进行通信，除非您的网站不受https支持");
		warn("如果您使用的公共网站不支持https协议，请及时作出更换，因为这代表着您的数据不够安全");
		warn("只是一条建议，并不影响您的使用 ;)");
	end

	if data == nil or type(data) ~= "string" then
		error("没有传输的内容，请检查输入是否正确");
		return;
	end

	if contenttype == nil or type(contenttype) ~= "table" then
		warn("您并没有设置一个传输类型，请设置一个传输类型");
		warn("如果您并不知道传输类型，请参考以下网页");
		warn("https://developer.roblox.com/en-us/api-reference/enum/HttpContentType");
		return;
	end

	if compress == nil or type(contenttype) ~= "boolean" then
		warn("您并没有设置compress，已自动设置为false");
		compress = false;
	end

	print("默认设置已完成，执行发送函数");

	if isjson then
		for k, v in pairs(data) do
			text = text .. ("&%s=%s"):format(httpservice:UrlEncode(k),httpservice:UrlEncode(v))
		end
		text = text:sub(2);
	else
		text = data;
	end

	local response = httpservice:PostAsync(url, text, contenttype, compress,headers);

	if response then
		print("正确发送到了http");
		return response;
	else
		error("发送http失败，请检查您的编码格式是否正确，或检查您的网站是否能被Roblox获取到");
		return;
	end

end

-- 非必要请不要使用此函数，他会卡住脚本的运行并且等待运行完整
-- https://developer.roblox.com/en-us/api-reference/function/HttpService/RequestAsync
-- https://developer.mozilla.org/en-US/docs/Glossary/Response_header
-- 向网站发送请求
--- @param url string 获取请求的网址，可以使用ip但必须加上http/https才可以使用，不然报错
--- @param method string 此请求使用的 HTTP 方法，通常是 GET 或 POST, 参考此链接：https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods
--- @param headers table HTTP头部, 用于此请求的头的字典。接受大多数但不是所有 HTTP 头
--- @param body string|table 请求正文。可以是任意字符串，包括二进制数据。在使用 GET 或 HEAD HTTP 方法时必须排除在外。在发送 JSON 或其他格式时可能需要指定 Content-Type 头。
--- @param isjson boolean 为了方便自己以及不想多填写重复代码写的判断
http.request = function(url, method, headers, body, isjson)

	if url == nil or (url.find(url,"http://") == nil and url.find(url,"https://") == nil) or type(url) ~= "string" then
		error("设置有误，请设置您的获取地址");
		return;
	end

	if url.find(url,"http://") and url.find(url,"https://") == nil then
		warn("检测到没有使用SSL/HTTPS协议，确保您的数据安全，十分建议您使用https协议进行通信，除非您的网站不受https支持");
		warn("如果您使用的公共网站不支持https协议，请及时作出更换，因为这代表着您的数据不够安全");
		warn("只是一条建议，并不影响您的使用 ;)");
	end

	if method ~= nil and type(method) ~= "string" then
		error("您没有对设置请求方法，请重新设置\n如果您对请求方法没什么概念，请参考以下链接\nhttps://developer.mozilla.org/en-US/docs/Web/HTTP/Methods\n如果您只是单纯的想用GET或者POST的话，请直接使用相关函数，不要使用此函数");
	end

	if headers ~= nil and type(headers) ~= "table" then
		error("您没有对设置对HTTP头部，请重新设置\n也有可能是您没有写成表");
	end

	if body ~= nil and type(body) ~= "table" then
		error("您没有设置对需要发送的内容，请重新设置\n也有可能是您没有写成表");
	end

    local response_table = {
        Url = url,
    }

    if method ~= nil and type(method) == "string" then
        response_table.Method = method
    end

    if headers ~= nil and type(method) == "table" then
        response_table.Headers = headers
    end

    if body ~= nil and type(method) == "table" then
        response_table.Body = isjson and httpservice:JSONEncode(body) or body
    end


	local response = httpservice:RequestAsync(response_table)

	if response.Success then
		print("请求成功");
	else
		error("请求失败:", response.StatusCode, response.StatusMessage);
	end


end

--普通的转百分号编码
--之前还以为要自己转，结果他自己就好了
--当使用特殊符号或者包含中文的链接的时候请使用这个
--原本想在get和post自动化这个，然后发现会有误判的情况
--- @param text string 需要编码的文本
http.urlencode = function(text)
	print("检测到使用此函数，检测设置中...");

	--默认设置
	if text == nil or type(text) ~= "string" then
		error("输入有误，请检查你的设置");
		return;
	end

	print("默认设置已完成，执行编码函数");
	local response = httpservice:UrlEncode(text)

	if response then
		print("编码成功")
		return response;
	else
		error("编码失败，请检查你的设置是否有误");
		return;
	end
end

--json相关函数
--将lua表转换成json格式的函数
--- @param tablelist table 需要转换的lua表
http.json.encode = function(tablelist)

	print("检测到使用此函数，检测设置中...");

	if tablelist == nil or type(tablelist) ~= "table" then
		error("没有传输的内容，请检查输入是否正确");
		return;
	end
	print("默认设置已完成，执行编码函数");
	local json = httpservice:JSONEncode(tablelist);

	if json then
		print("编码成功");
		return json;
	else
		error("编码失败，请检查你的设置是否有误");
		return;
	end
end

--json相关函数
--将json格式转换成lua表的函数
--- @param str string 需要转换的json表
http.json.decode = function(str)
	print("检测到使用此函数，检测设置中...");

	if str == nil or type(str) ~= "string" then
		error("没有传输的内容，请检查输入是否正确");
		return;
	end
	print("默认设置已完成，执行解码函数");
	local json = httpservice:JSONDecode(str);

	if json then
		print("解码成功");
		return json;
	else
		error("解码失败，请检查你的设置是否有误");
		return;
	end
end

--可能识别玩家有用，我不知道
--反正在http类里那我就写进来了
http.uuid = function(wrapInCurlyBraces)
	print("检测到使用此函数，检测设置中...");

	if wrapInCurlyBraces == nil or type(wrapInCurlyBraces) ~= "boolean" then
		error("没有传输的内容，请检查输入是否正确");
		return;
	end

	print("默认设置已完成，执行生成函数");
	local result = httpservice:GenerateGUID(wrapInCurlyBraces);

	if result then
		print("生成成功");
		return result;
	else
		error("生成失败，请检查你的设置是否有误");
		return;
	end

end

return http;
