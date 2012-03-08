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
	struct MaxSpotlightUtil
	(
		private _appLabel = "<MaxSpotlight>",
		
		
		public
		function getExactNodesOrNodesMatchingPattern txt =
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
		function selectNodeByName txt =
		(
			/*
				Checks if a node with the exact txt is in scene and selects it.
				It does this even if other nodes include that text but also more.
				If no exact match, it selects all objects which includes the text.
			 */			
			
			local nodes = getExactNodesOrNodesMatchingPattern txt
			select nodes
			return nodes
		),		
		
		
		private
		function logNumNodes mode numNodes =
		(
			format "\n% %: % node(s)\n" _appLabel mode numNodes
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
		
		
		public
		function logResults nodeNames =
		(
			local outStream = StringStream ""
			
			for nodeNameOn in nodeNames do
				format "% %\n" _appLabel nodeNameOn to:outStream
			
			format "%" (outStream as String)
		)
	)
)