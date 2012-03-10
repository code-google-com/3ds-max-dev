/*
 *	Copyright (c) 2012, Pixelbaker
 *	All rights reserved.
 *
 *	Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *		Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *		Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 *	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

(
	local SelectAndLogUtil
	struct SelectAndLogUtil
	(
		/*
			Struct for performing node selection and logging based on string patterns.
		 */
		
		private _appLabel = "<MaxSpotlight>",
		
		
		private
		function isLineLimitActive lineLimit = 
		(
			return lineLimit > 0
		),
		
		
		private
		function addLineLimitLog stream lineLimit =
		(
			local pattern = "\n% ... (Reached line limit(%). Other nodes are ommitted.)\n"
			format pattern _appLabel lineLimit to:stream
		),
		
		
		public
		function logNodeNames nodeNames lineLimit =
		(
			local logStream = StringStream ""
			
			for i=1 to nodeNames.count while not isLineLimitActive lineLimit or i <= lineLimit do
				format "% %\n" _appLabel nodeNames[i] to:logStream
			
			if isLineLimitActive lineLimit and nodeNames.count > lineLimit then 
				addLineLimitLog logStream lineLimit
			
			if nodeNames.count > 0 then
				format "%\n" (logStream as String)
		),
		
		
		private
		function logNumNodes mode numNodes =
		(
			format "% %: % node(s)\n" _appLabel mode numNodes
		),
		
		
		public
		function logSelectedNumNodes numNodes =
		(
			logNumNodes "Selected" numNodes
		),
		
		
		public
		function logFoundNumNodes numNodes =
		(
			
			logNumNodes "Found" numNodes
		),
		
		
		private
		function getNodesWithExactOrPatternMatch txt =
		(
			local exactHits = getNodeByName txt all:true
			
			if exactHits.count > 0 then
				return exactHits
			else (
				local pattern = "*" + txt + "*"
				return for nodeOn in objects where matchPattern nodeOn.name pattern:pattern collect nodeOn			
			)
		),
		
		
		public
		function getNodeNamesWithExactOrPatternMatch txt =
		(
			local nodes = getNodesWithExactOrPatternMatch txt
			return for nodeOn in nodes collect nodeOn.name
		),
		
		
		public
		function selectNodes txt =
		(
			/*
				Checks if a node with the exact txt is in scene and selects it.
				It does this even if other nodes include that text but also more.
				If no exact match, it selects all objects which includes the text.
			 */			
			
			local nodes = getNodesWithExactOrPatternMatch txt
			select nodes
			return nodes
		),
		
		
		public
		function selectNodesAndLog txt =
		(
			local nodes = selectNodes txt
			logSelectedNumNodes nodes.count
		)
	)
)