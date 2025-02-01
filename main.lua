-----------------------------------------------------------------------------------------
--
-- Adverb Wall 2 - WIP empty - main.lua
--
-----------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

-- Helper/Utility function:
-- for testing/debugging purposes (see the main program below):
function printObjectTexts(containerTable)
	print(" ")
	print('In printObjectTexts:')
	print(" ")
	-- the containerTable is a "wrapper table" of tables inside of it.
	-- each table has in it display.newText() objects, 
	-- so we need to go through the "container table" and 
	-- then loop through all display.newText() objects to extract the text
	local containerTexts = {}
	for nTables = 1, #containerTable do
		local texts = {}
		for n = 1, #containerTable[nTables] do
			table.insert(texts, containerTable[nTables][n].text) -- if containing display.newText() objects
			-- table.insert(texts, containerTable[nTables][n])  -- if containing text strings (not display.newText() objects)
		end
		table.insert(containerTexts, texts)
		print(table.concat(texts, ';'))
		-- print(" ")s
	end
	return containerTexts -- in case the whole container is needed
end


-- Your code here

local dWidth = display.contentWidth
local dHeight = display.contentHeight

words = {'hurriedly', 'aggressively', 'quickly', 'speedily', 'swiftly', 'rapidly', 'briskly', 'nimbly', 'sprightly', 'zippily', 'carefully', 'languidly', 'cautiously', 'calmly', 'casually', 'deliberately', 'gingerly', 'gradually', 'haltingly', 'lazily', 'nonchalantly', 'leisurely', 'unhurriedly', 'hopefully', 'optimistically', 'accurately', 'adequately', 'gently', 'closely', 'completely', 'correctly', 'effectively', 'efficiently', 'fully', 'nicely', 'properly', 'smoothly', 'strongly', 'successfully', 'thoroughly', 'ably'}

local function descending( a, b )
	return a > b
end



local function sortWords( words, sortOrder )
	if sortOrder == "descending" then
		table.sort( words )
		return words
	elseif sortOrder == "ascending" then
		table.sort( words, descending )
		return words
	end
	return {"a", "fatal", "error", "occurred"}
end


function createWordStructure( words, sortOrder, displayMode )
	sortedWords = sortWords(words, sortOrder)
	-- print(table.concat(sortedWords, "; "))
	rowContainer = {}
	for i=1,#sortedWords do
		rowTable = {}
		for j=1,6 do
			word = table.remove(sortedWords)
			if word then
				x = j*75 - 20
				y = i*45 - 20
				wordObj = display.newText(word, x, y, "Arial", 14)
				table.insert(rowTable, wordObj)
			end
		end
		table.insert(rowContainer, rowTable)
	end

	if displayMode == "by column" or displayMode == "hide column" then
		colContainer = {}
		for i=1,#rowContainer[1] do
			colTable = {}
			for j=1,#rowContainer do
				wordObj = rowContainer[j][i]
				if wordObj then
					table.insert(colTable, wordObj)
				end
			end
			table.insert(colContainer, colTable)
		end
		rowContainer = colContainer
	end

	if displayMode == "random word" or displayMode == "random hide" then
		for i=1,#rowContainer do
			for j=1,#rowContainer[i] do
				table.insert(randomList, rowContainer[i][j])
			end
		end
		ShuffleInPlace(randomList)
	end

	return rowContainer
end


rowToDisplay = 1
function displayRow()
	local row = allWordObjects[rowToDisplay]
	for i=1,#row do
		-- row[i].alpha = 1
		transition.to(row[i], {alpha=1, time=1000, transition=easing.outInBack})
	end
	rowToDisplay = rowToDisplay + 1
end

function hideRow()
	local row = allWordObjects[rowToDisplay]
	for i=1,#row do
		-- row[i].alpha = 1
		transition.to(row[i], {alpha=0, time=1000, transition=easing.outInBack})
	end
	rowToDisplay = rowToDisplay + 1
end

function displayColumn()
	displayRow()
end

function hideColumn()
	hideRow()
end

randomList = {}
wordToDisplay = 1
randomAmount = 6
function displayWord()
	for i = 1,randomAmount do
		transition.to(randomList[wordToDisplay], {alpha=1, time=1000, transition=easing.outInBack})
		wordToDisplay = wordToDisplay + 1
	end
end

function hideWord()
	for i = 1,randomAmount do
		transition.to(randomList[wordToDisplay], {alpha=0, time=1000, transition=easing.outInBack})
		wordToDisplay = wordToDisplay + 1
	end
end

function ShuffleInPlace(t)
    for i = #t, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
end

function hideAllWords()
	for i=1,#allWordObjects do
		for j=1,#allWordObjects[i] do
			allWordObjects[i][j].alpha = 0
		end
	end
end

function showAllWords()
	for i=1,#allWordObjects do
		for j=1,#allWordObjects[i] do
			allWordObjects[i][j].alpha = 1
		end
	end
end

function displayWords(allWords, displayMode)
	if displayMode == 'by row' then
		hideAllWords()
		timer.performWithDelay( 800, displayRow , #allWords ) 
	end
	if displayMode == 'by column' then
		hideAllWords()
		timer.performWithDelay( 800, displayColumn , #allWords )
	end
	if displayMode == 'random word' then
		hideAllWords()
		-- Create a list of random order by using my amazing random sort function
		timer.performWithDelay( 800, displayWord , nWords )
	end
	if displayMode == 'hide row' then
		showAllWords()
		timer.performWithDelay( 800, hideRow , #allWords ) 
	end
	if displayMode == 'hide column' then
		showAllWords()
		timer.performWithDelay( 800, hideColumn , #allWords ) 
	end
	if displayMode == 'random hide' then
		showAllWords()
		timer.performWithDelay( 800, hideWord , #allWords ) 
	end
end



--------------
-- main - WIP
--------------

sortOrder = 'ascending'
-- sortOrder = 'descending'

-- displayMode = 'by row'
-- displayMode = 'by column'
-- displayMode = 'random word'
displayMode = 'hide row'
-- displayMode = 'hide column'
-- displayMode = 'random hide'

-- create a (container) table of (inner) tables. Each inner table is either a row or a column, 
-- depending on the displayMode:
nWords = #words -- how many words do we have to display
allWordObjects = createWordStructure(words, sortOrder, displayMode)

-- for testing/debugging purposes use the following utility/helper function 
-- to print to the console:
printObjectTexts(allWordObjects)

-- really display on the device, after the above works:
function displayRunner()
	displayWords(allWordObjects, displayMode)
end

displayRunner()
















