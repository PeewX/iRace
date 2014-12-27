CSprite = {}

function CSprite:constructor(path, width, height, columns, rows, count, delay)
	self.Imagepath = path
	self.Width = width
	self.Height = height
	
	self.Columns = columns
	self.Rows = rows
	
	self.Cellwidth = self.Width/self.Columns
	self.Cellheight = self.Height/self.Rows
	
	self.Count = count
	self.Delay = delay or 100
	
	self.RenderStart = 0
	self.RenderTimes = 1
	self.eOnRender = bind(CSprite.onRender, self)
end

function CSprite:destructor()

end

function CSprite:startRender(times, x, y, width, height)
	self.RenderTimes = times

	self.RenderData = {
		["X"]=x or 0,
		["Y"]=y or 0,
		["Width"]= width or (self.Width/self.Columns) ,
		["Height"]= height or (self.Height/self.Rows),
	}
	
	self.RenderStart = getTickCount()
	
	addEventHandler("onClientRender", getRootElement(), self.eOnRender)
end

function CSprite:stopRender()
	removeEventHandler("onClientRender", getRootElement(), self.eOnRender)
end

function CSprite:renderOneFrame(count, x ,y , width, height)
	dxDrawImageSection(x,y,width,height,(count%self.Columns)*self.Cellwidth, math.floor(count/self.Columns)*self.Cellheight, self.Cellwidth, self.Cellheight, self.Imagepath)
end

function CSprite:onRender()
	if ( getTickCount()-self.RenderStart > self.Delay*self.Count*self.RenderTimes ) and (self.RenderTimes > 0)  then
		self:stopRender()
	else
		self:renderOneFrame( math.floor( math.floor(getTickCount()- self.RenderStart) /self.Delay)%self.Count, self.RenderData["X"], self.RenderData["Y"], self.RenderData["Width"], self.RenderData["Height"])
	end
end